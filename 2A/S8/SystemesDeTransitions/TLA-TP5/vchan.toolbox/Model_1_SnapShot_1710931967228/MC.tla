---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931963176552000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931963176553000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931963176554000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931963176555000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931963176556000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931963176559000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:52:43 CET 2024 by yelalami
