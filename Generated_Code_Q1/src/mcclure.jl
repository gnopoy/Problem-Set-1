include("Include.jl")

# define some colors -
const shaded_color_value = "lightgray"
const mean_color_value = "dimgray"
const experimental_color_value = "black"

const P1_color = "blue"
const P1_shaded_color="skyblue"

const P2_color = "orange"
const P2_shaded_color="navajowhite"

const P3_color = "green"
const P3_shaded_color="lightgreen"


A = readdlm("/Users/gnopo/Problem_set_1/Generated_Code_Q1/figs/Open_complex_formation_nodelay.dat")
B = readdlm("/Users/gnopo/Problem_set_1/Generated_Code_Q1/figs/Open_complex_formation_delay.dat")

# Make some plots -
# P1 -

plot(A[:,1], A[:,2],lw=2,color=P1_color)


# P2 -

plot(B[:,1],B[:,2],lw=2,color=P2_color)


# P3 -

#plot(time_array_3,P3_mean,lw=2,color=P3_color)
#fill_between(time_array,vec(P3_lower_bound),vec(P3_upper_bound),color=P3_shaded_color,lw=3)

# Dump to disk -
savefig("/Users/gnopo/Problem_set_1/Generated_Code_Q1/figs/Washout-3G.pdf")
