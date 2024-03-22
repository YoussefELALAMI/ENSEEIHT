---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931291587442000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931291587443000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931291587444000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931291587445000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931291587446000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931291587449000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:41:31 CET 2024 by yelalami
