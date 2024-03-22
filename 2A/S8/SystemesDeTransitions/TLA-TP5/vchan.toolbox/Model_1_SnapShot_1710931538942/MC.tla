---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931535919530000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931535919531000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931535919532000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931535919533000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931535919534000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931535919537000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:45:35 CET 2024 by yelalami
