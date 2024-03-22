---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931437862475000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931437862476000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931437862477000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931437862478000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931437863479000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931437863482000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:43:57 CET 2024 by yelalami
