---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931523172519000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931523172520000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931523172521000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931523172522000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931523172523000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931523173526000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:45:23 CET 2024 by yelalami
