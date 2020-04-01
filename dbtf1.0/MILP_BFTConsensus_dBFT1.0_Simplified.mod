using JuMP, GLPK
#estou deixando um valor aleatorio nos parametros por enquanto,
f = 10  #number of faulty/Byzantine replicas.
N = 10  #total number of replicas. $N = |R| = |R^{OK}| + |R^{BYZ}| = 3f + 1$.
M = 10  #safety level. $M = 2f + 1$.

 #=
 consensus replica $i$ from set of replicas R.
$R^{OK}$ is non-byzantine set.
$R = R^{OK} \cup R^{BYZ} = 1M+1..M+F$,
such that $R^{OK} \cap R^{BYZ} = \emptyset$.
=#
R=1:N
R_OK=1:M

#View $v$ from set of possible views $V$ (number of views may be limited to the number of consensus nodes $N$). $V = \{v_0, v_1, \cdots , v_{N-1}\}$
V = 1:N

#time unit $t$ from set of discrete time units $T$.  $T = \{t_0, t_1, t_2,  \cdots \}$.
tMax = 10
T = 1:tMax;
m = model()

# ===================
#DECISION VARIABLES #
@variable(m, primary[R,V], Bin)
@variable(m, SendPreqReq[T,R,V], Bin)
@variable(m, SendPrepResp[T,R,V], Bin)
@variable(m,SendCV[T,E,V], Bin)
# RecvPrepReq{14,1,2,3} sinalizes that the node 1 has received a prepere_request from the node 2 during the view 3
@variable(m, RecvPrepReq[T,R,R,V], Bin)
#/* RecvPrepResp{18,4,5,3} sinalizes that the node 4 has received a prepere_response from the node 5 during the view 3
@variable(m, RecvPrepResp[T,R,R,V], Bin)
#/* RecvCV{18,1,3,3} sinalizes that the node 1 has received a ChangeView from the node 3 during the view 3
@variable(RecvCV[T,R,R,V], Bin)
@variable(m, BlockRelay[T,R,V], Bin)
# DECISION VARIABLES}
# ==================

# ====================
#/{AUXILIARY VARIABLES
@variable(m, totalBlockRelayed)
@variable (m, prepReqSendPerNodeAndView[R,V]>=0, Int)
@variable(m, prepRespSendPerNodeAndView[R,V] >=0, Int)
@variable(m, prepRespPerNodeAndView[R,V] >=0, Int)
@variable(m, changeViewPerNodeAndView[R,V] >=0, Int)
@variable(m, prepReqPerNodeAndView[R,V] >=0, Int)
@variable(m, blockRelayPerNodeAndView[R,V] >=0, Int)
@variable(m, lastRelayedBlock, Int)
@variable(m, blockRelayed[V], Bin)
#  AUXILIARY VARIABLES}
# ===================
