---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931471398508000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931471398509000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931471398510000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931471398511000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931471398512000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931471398515000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:44:31 CET 2024 by yelalami
