---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931593807541000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931593807542000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931593807543000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931593807544000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931593807545000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931593808548000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:46:33 CET 2024 by yelalami
