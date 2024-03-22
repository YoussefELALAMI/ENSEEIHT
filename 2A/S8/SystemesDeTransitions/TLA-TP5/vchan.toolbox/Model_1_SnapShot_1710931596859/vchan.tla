------------------------------- MODULE vchan -------------------------------
EXTENDS Naturals, Sequences, FiniteSets

CONSTANT Byte \* 0..255, but overridable for modelling purposes. Consider especially 1..max(Len(Sent))+MaxWriteLen

(* The size of the ring buffer in bytes. *)
CONSTANT BufferSize
ASSUME BufferSize \in Nat \ {0}

(* The most data a sender will try to send in one go. *)
CONSTANT MaxWriteLen
ASSUME MaxWriteLen \in Nat \ {0}

(* The most data a receiver will try to read in one go. *)
CONSTANT MaxReadLen
ASSUME MaxReadLen \in Nat \ {0}

(* Endpoint automata *)
Idle == "Idle"
Writing == "Writing"
AfterWriting == "AfterWriting"
Reading == "Reading"
AfterReading == "AfterReading"
Blocked == "Blocked"
Done == "Done"
SenderStates == {Idle, Writing, AfterWriting, Blocked, Done}
ReceiverStates == {Idle, Reading, AfterReading, Blocked, Done}

----------------

Min(x, y) == IF x < y THEN x ELSE y

(* Take(m, i) is the first i elements of message m. *)
Take(m, i) == SubSeq(m, 1, i)

(* Everything except the first i elements of message m. *)
Drop(m, i) == SubSeq(m, i + 1, Len(m))

----------------

VARIABLES
  (* history variables (for modelling and properties) *)
  Sent,
  Got,
  
  (* The remaining data that has not yet been added to the buffer: *)
  msg,
  
  (* status of the endpoints. *)
  SenderLive,   \* init true, cleared by sender
  ReceiverLive, \* init true, cleared by receiver

  SenderState,   \* {Idle, Writing, AfterWriting, Blocked, Done}
  ReceiverState, \* {Idle, Reading, AfterReading, Blocked, Done}

  (* NotifyWrite is a shared flag that is set by the receiver to indicate that it wants to know when data
     has been written to the buffer. The sender checks it after adding data. If set, the sender
     clears the flag and notifies the receiver using the event channel. This is represented by
     ReceiverIT being set to TRUE. It becomes FALSE when the receiver handles the event. *)
  NotifyWrite,   \* Set by receiver, cleared by sender
  ReceiverIT,    \* Set by sender, cleared by receiver

  (* Buffer represents the data in transit from the sender to the receiver. *)
  Buffer,
  
  (* NotifyRead is a shared flag that indicates that the sender wants to know when some data
     has been read and removed from the buffer (and, therefore, that more space is now available).
     If the receiver sees that this is set after removing data from the buffer,
     it clears the flag and signals the sender via the event channel, represented by SenderIT. *)
  NotifyRead,         \* Set by sender, cleared by receiver
  SenderIT            \* Set by receiver, cleared by sender

----------------------------------------------------------------

(* The type of the entire message the client application sends, of size up to MaxWriteLen. *)
(* This is a non-empty bounded Seq(Byte). *)
\* MSG(len) == UNION { [ 1..N -> Byte ] : N \in 1..len }
(* Override MSG with this to limit Sent to the form << 1, 2, 3, ... >>.
   This is much faster to check and will still detect any dropped or reordered bytes. *)
MSG(len) == { [ x \in 1..N |-> Len(Sent) + x ] : N \in 1..len }
MESSAGE == MSG(MaxWriteLen)

vars == << Sent, Got, SenderLive, ReceiverLive, SenderState, ReceiverState, Buffer, msg, NotifyWrite, ReceiverIT, NotifyRead, SenderIT >>

----------------------------------------------------------------

\* Initial state.
Init == /\ SenderLive = TRUE
        /\ ReceiverLive = TRUE
        /\ ReceiverState = Idle
        /\ SenderState = Idle
        /\ Got = << >>
        /\ Sent = << >>
        /\ msg = << >>
        /\ Buffer = << >>
        /\ NotifyWrite = FALSE
        /\ ReceiverIT = FALSE
        /\ NotifyRead = FALSE
        /\ SenderIT = FALSE

----------------

\* Transition Idle -> Done. Receiver is no longer live.
SenderIdle1 == /\ SenderLive
               /\ SenderState = Idle
               /\ ~ReceiverLive
               /\ SenderState' = Done
               /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, ReceiverState, Buffer, msg, NotifyWrite, ReceiverIT, NotifyRead, SenderIT >>

\* Transition Idle -> Writing. A new message is to be sent.
SenderIdle2 == /\ SenderLive
               /\ SenderState = Idle
               /\ \E m \in MSG(MaxWriteLen) :
                     /\ msg' = m
                     /\ Sent' = Sent \o m
               /\ SenderState' = Writing
               /\ UNCHANGED << Got, SenderLive, ReceiverLive, ReceiverState, Buffer, NotifyWrite, ReceiverIT, NotifyRead, SenderIT >>

\* Transition Writing -> AfterWriting. Some prefix of msg is added to the buffer (without overrunning it) 
(* Transférer une partie de msg dans le buffer. 
    Combien ? entre 1 octet et le Max possible (Min(Len(msg), MaxWriteLen)) *)
SenderWrite1 == /\ SenderState = Writing
                /\ \E k \in 1..Min(Len(msg), MaxWriteLen) :
                    /\ BufferSize >= Len(Buffer) + k \* il y a de la place
                    /\ Buffer' = Buffer \o Take(msg,k)
                    /\ msg' = Drop(msg,k)
                /\ NotifyRead' = TRUE
                /\ SenderState' = AfterWriting
                /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, ReceiverState, NotifyWrite, ReceiverIT, SenderIT >>

\* Transition Writing -> Blocked. The buffer is full.
SenderWrite2 == /\ SenderState = Writing
                /\ Len(Buffer) = BufferSize
                /\ NotifyRead' = TRUE
                /\ SenderState' = Blocked
                /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, ReceiverState, Buffer, msg, NotifyWrite, ReceiverIT, SenderIT >>
                   
\* Transition AfterWriting -> Idle. msg is empty, all bytes have been sent. Set ReceiverIT if requested.
SenderWriteNext1 == /\ SenderState = AfterWriting
                    /\ Len(msg) = 0
                    /\ IF NotifyWrite THEN ReceiverIT' = TRUE /\ NotifyWrite' = FALSE ELSE UNCHANGED <<  ReceiverIT, NotifyWrite >>
                    /\ SenderState' = Idle
                    /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, Buffer, msg, ReceiverState, NotifyRead, SenderIT >>
                        

\* Transition AfterWriting -> Blocked. msg is not empty, waiting to send more. Set ReceiverIT if requested.
SenderWriteNext2 == /\ SenderState = AfterWriting
                    /\ Len(msg) /= 0
                    /\ IF NotifyWrite THEN ReceiverIT' = TRUE /\ NotifyWrite' = FALSE ELSE UNCHANGED <<  ReceiverIT, NotifyWrite >>
                    /\ SenderState' = Blocked
                    /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, Buffer, msg, ReceiverState, NotifyRead, SenderIT >>

\* Transition Blocked -> Writing.
\* initial version: no condition (non-deterministic)
\* final version: IT received while receiver is live.
SenderUnblock1 == /\ SenderState = Blocked
                  /\ ReceiverLive
                  /\ IF NotifyRead THEN SenderIT' = FALSE /\ NotifyRead' = FALSE ELSE UNCHANGED << SenderIT, NotifyRead >>
                  /\ SenderState' = Writing
                  /\ UNCHANGED << Sent, Got, SenderLive, Buffer, ReceiverState, msg, NotifyWrite, ReceiverIT, ReceiverLive >>
                   

\* Transition Blocked -> Done.
\* initial version: no condition (non-deterministic)
\* final version: IT received while receiver is dead.
SenderUnblock2 == /\ SenderState = Blocked
                  /\ ~ReceiverLive
                  /\ IF NotifyRead THEN SenderIT' = FALSE /\ NotifyRead' = FALSE ELSE UNCHANGED << SenderIT, NotifyRead >>
                  /\ SenderState' = Done
                  /\ UNCHANGED << Sent, Got, SenderLive, Buffer, ReceiverState, msg, NotifyWrite, ReceiverIT, ReceiverLive >>

\* Transition any state -> Done. Sender is no longer live.
SenderEnd == /\ SenderState /= Done
             /\ ~SenderLive
             /\ SenderState' = Done
             /\ UNCHANGED << Sent, Got, Buffer, ReceiverState, msg, NotifyWrite, NotifyRead, ReceiverLive, ReceiverIT, SenderIT, SenderLive >>

----------------

\* Transition Idle -> Blocked. Buffer is empty and sender is live.
ReceiverIdle1 == /\ ReceiverLive
                 /\ ReceiverState = Idle
                 /\ SenderLive
                 /\ Len(Buffer) = 0
                 /\ ReceiverState' = Blocked
                 /\ NotifyWrite' = TRUE
                 /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, SenderState, Buffer, msg, ReceiverIT, NotifyRead, SenderIT >>

\* Transition Idle -> Reading. Buffer is not empty.
ReceiverIdle2 == /\ ReceiverLive
                 /\ ReceiverState = Idle
                 /\ Len(Buffer) /= 0
                 /\ ReceiverState' = Reading
                 /\ NotifyWrite' = TRUE
                 /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, SenderState, Buffer, msg, ReceiverIT, NotifyRead, SenderIT >>

\* Transition Idle -> Done. Sender is dead and buffer is empty.
ReceiverIdle3 == /\ ReceiverLive
                 /\ ReceiverState = Idle
                 /\ ~SenderLive
                 /\ Len(Buffer) = 0
                 /\ ReceiverState' = Done
                 /\ NotifyWrite' = TRUE
                 /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, SenderState, Buffer, msg, ReceiverIT, NotifyRead, SenderIT >>

\* Transition Reading -> AfterReading. Extract some bytes from buffer.
ReceiverRead == /\ ReceiverState = Reading
                /\ \E k \in 1..Min(Len(Buffer), MaxReadLen) :
                    /\ Buffer' = Drop(Buffer,k)
                    /\ Got' = Got \o Take(Buffer,k)
                /\ ReceiverState' = AfterReading
                /\ UNCHANGED << Sent, SenderLive, ReceiverLive, SenderState, msg, ReceiverIT, NotifyRead, NotifyWrite, SenderIT >>

\* Transition AfterReading -> Idle. Back to Idle. Set SenderIT if requested.
ReceiverReadNext == /\ ReceiverState = AfterReading
                    /\ IF NotifyRead THEN SenderIT' = TRUE /\ NotifyRead' = FALSE ELSE UNCHANGED << SenderIT, NotifyRead >>
                    /\ ReceiverState' = Idle
                    /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, SenderState, Buffer, msg, ReceiverIT, NotifyWrite >>

\* Transition Blocked -> Idle.
\* initial version: no condition (non-deterministic)
\* final version: IT received.
ReceiverUnblock == /\ ReceiverState = Blocked
                   /\ ReceiverIT' = FALSE
                   /\ ReceiverState' = Idle
                   /\ UNCHANGED << Sent, Got, SenderLive, ReceiverLive, SenderState, Buffer, SenderIT, msg, NotifyWrite, NotifyRead >>

\* Transition any state -> Done. Receiver is no longer live.
ReceiverEnd == /\ ReceiverState /= Done
               /\ ~ReceiverLive
               /\ ReceiverState' = Done
               /\ UNCHANGED << Sent, Got, SenderLive, Buffer, SenderState, msg, NotifyWrite, NotifyRead, SenderLive, ReceiverIT, SenderIT, ReceiverLive >>

----------------

(* Asynchronous abort of any endpoint. *)

\* Sender abruptly becomes dead. It sends an IT to receiver on dying.
SenderClose == /\ SenderLive
               /\ SenderLive' = FALSE
               /\ ReceiverIT' = TRUE
               /\ UNCHANGED << Sent, Got, ReceiverState, ReceiverLive, SenderState, Buffer, SenderIT, msg, NotifyWrite, NotifyRead >>

\* Receiver abruptly becomes dead. It sends an IT to sender on dying.
ReceiverClose == /\ ReceiverLive
               /\ ReceiverLive' = FALSE
               /\ SenderIT' = TRUE
               /\ UNCHANGED << Sent, Got, ReceiverState, ReceiverIT, SenderState, Buffer, SenderLive, msg, NotifyWrite, NotifyRead >>

----------------

(* Spurious interruption *)

\* A SenderIT spuriously appears.
\* A ReceiverIT spuriously appears.

----------------

SenderNext == SenderIdle1 \/ SenderIdle2 \/ SenderWrite1 \/ SenderWrite2 \/ SenderWriteNext1 \/ SenderWriteNext2 \/ SenderUnblock1 \/ SenderUnblock2 \/ SenderEnd

ReceiverNext == ReceiverIdle1 \/ ReceiverIdle2 \/ ReceiverIdle3 \/ ReceiverRead \/ ReceiverReadNext \/ ReceiverUnblock \/ ReceiverEnd

Next == \/ SenderNext \/ ReceiverNext
        \/ SenderClose \/ ReceiverClose

\* Weak fairness on sender and weak fairness on receiver: both will progress as long as they do not deadlock.
\* No fairness on {Sender,Receiver}Close or spurious IT: these events may never occur.
Fairness == WF_vars(SenderNext) /\ WF_vars(ReceiverNext)

Spec == Init /\ [][Next]_vars /\ Fairness

----------------------------------------------------------------

TypeOk ==
  /\ Sent \in Seq(Byte)
  /\ Got \in Seq(Byte)
  /\ Buffer \in Seq(Byte)
  /\ SenderLive \in BOOLEAN
  /\ ReceiverLive \in BOOLEAN
  /\ NotifyWrite \in BOOLEAN
  /\ SenderIT \in BOOLEAN
  /\ NotifyRead \in BOOLEAN
  /\ ReceiverIT \in BOOLEAN
  /\ SenderState \in {Idle, Writing, AfterWriting, Blocked, Done}
  /\ ReceiverState \in {Idle, Reading, AfterReading, Blocked, Done}
  /\ msg \in Seq(Byte)

(* Whatever we receive is the same as what was sent (i.e. `Got' is a prefix of `Sent') *)
Integrity == (Take(Sent, Len(Got)) = Got)
  
(* Any data that the write function reports has been sent successfully (i.e.
   data in Sent when it is back at "ready") will eventually be received (if
   the receiver doesn't close the connection). In particular, this says that
   it's OK for the sender to close its end immediately after sending some data. *)
Availability ==
  ([](SenderLive /\ ReceiverLive )) => (\A x \in 0..Cardinality(Byte) : x = Len(Sent) /\ SenderState = Idle ~> (Len(Got) >= x))

(* If either side closes the connection, both end up in their Done state *)
ShutdownOK == (~SenderLive \/ ~ReceiverLive) ~> (SenderState = Done /\ ReceiverState = Done)

(* If both ends never close the connection (and Sent is finite), then the receiver eventually gets all the sent bytes. *)
NoLoss == ([](SenderLive /\ ReceiverLive )) => <>[](Got = Sent)

================================================================
