include("Include.jl")

# define some colors -
const shaded_color_value = "lightgray"
const mean_color_value = "dimgray"
const experimental_color_value = "black"

const P1_color = "blue"
const P1_shaded_color="skyblue"

# Script to solve the balance equations -
time_start = 0.0
time_stop = 1.0
time_step_size = 0.01
number_of_timesteps = length(time_start:time_step_size:time_stop)

# How many samples do we want to explore?
number_of_samples = 10
sigma = 0.05

# initialize storage -
time_array = []
P1_array = zeros(number_of_timesteps,number_of_samples)

# main loop -
for sample_index = 1:number_of_samples

  # Load the data dictionary (default parameter values) -
  data_dictionary = DataDictionary(time_start,time_stop,time_step_size)

  # Pertub the RNAPs and Ribosome abundance -
  rnapII_concentration  = data_dictionary["rnapII_concentration"] # muM
	ribosome_concentration  = data_dictionary["ribosome_concentration"] # muM

  rnapII_concentration = abs(rnapII_concentration*(1+sigma*randn()))
  ribosome_concentration  = abs(ribosome_concentration*(1+sigma*randn()))

  data_dictionary["rnapII_concentration"] = rnapII_concentration  # muM
	data_dictionary["ribosome_concentration"] = ribosome_concentration # muM

  # Run the washout simulation -
  (T,X) = open_complex_simulation(time_start,time_stop,time_step_size,data_dictionary)

  time_array = T
  for (time_index,time_value) in enumerate(T)
    P1_array[time_index,sample_index] = X[time_index,3];

  end
end

# Confidence interval?
SF = (1.96/sqrt(number_of_samples))

# Make some plots -
# P1 -
P1_mean = mean(P1_array,2)
P1_std = std(P1_array,2)
P1_lower_bound = P1_mean - SF*P1_std
P1_upper_bound = P1_mean + SF*P1_std
plot(time_array,P1_mean,lw=2,color=P1_color)
fill_between(time_array,vec(P1_lower_bound),vec(P1_upper_bound),color=P1_shaded_color,lw=3)

# Dump to disk
data_array_2 = [time_array P1_mean]
file_path_1 = "/Users/gnopo/Problem_set_1/Generated_Code_Q1/figs/Open_complex_formation_1000.dat"
writedlm(file_path_1, data_array_2)

# Dump to disk -
savefig("/Users/gnopo/Problem_set_1/Generated_Code_Q1/figs/Open_complex_formation_1000.png")
