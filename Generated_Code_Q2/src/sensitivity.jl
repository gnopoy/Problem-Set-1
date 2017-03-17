include("Include.jl")

# Load the dictionary
data_dictionary = DataDictionary(0.0, 0.0, 0.0)

# Where to find the files
path_to_sensitivity_files = "/Users/gnopo/Problem_set_1/Generated_Code/sensitivity"
file_pattern = "AdjSimulation-P"
time_skip = 240

# Calculate the sensitivity array
(T,SA) = calculate_sensitivity_array(path_to_sensitivity_files, file_pattern, time_skip, data_dictionary)

# Calculate identifiable parameters only sampling mRNA_gene_1 (index=4) and protein_gene_3 (index=9)
epsilon = 0.01
IP = estimate_identifiable_parameters(SA[[4,9,13,18,22,27,31,36],:], epsilon)

# Calculate length of IP and % of parameter identified
Q = length(IP)
Percent_identifiable = 100.0*Q/24.0

# Dump to disk
data_array_1 = [IP; Q; Percent_identifiable]
data_array_2 = [data_array_1]
file_path_1 = "/Users/gnopo/Problem_set_1/Generated_Code/Identifiable_Parameters/mRNA1_P3_measured.dat"
writedlm(file_path_1, data_array_2)
