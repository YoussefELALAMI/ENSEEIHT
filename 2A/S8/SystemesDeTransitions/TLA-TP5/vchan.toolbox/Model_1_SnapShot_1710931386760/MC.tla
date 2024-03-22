---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931383723464000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931383723465000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931383723466000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931383723467000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931383724468000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931383724471000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:43:03 CET 2024 by yelalami
