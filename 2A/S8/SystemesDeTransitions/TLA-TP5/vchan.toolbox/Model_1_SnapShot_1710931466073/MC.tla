---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931464019486000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931464019487000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931464019488000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931464019489000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931464019490000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931464019493000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:44:24 CET 2024 by yelalami
