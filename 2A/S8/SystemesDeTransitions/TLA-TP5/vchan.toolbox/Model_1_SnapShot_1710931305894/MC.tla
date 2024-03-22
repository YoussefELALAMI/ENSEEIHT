---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_1710931302826453000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_1710931302826454000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_1710931302826455000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_1710931302826456000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1710931302826457000 ==
Len(Sent) < 4
----
\* INVARIANT definition @modelCorrectnessInvariants:2
inv_1710931302827460000 ==
Len(Got) < 6
----
=============================================================================
\* Modification History
\* Created Wed Mar 20 11:41:42 CET 2024 by yelalami
