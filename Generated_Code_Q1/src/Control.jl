# ----------------------------------------------------------------------------------- #
# Copyright (c) 2017 Varnerlab
# Robert Frederick Smith School of Chemical and Biomolecular Engineering
# Cornell University, Ithaca NY 14850
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ----------------------------------------------------------------------------------- #
#
# ----------------------------------------------------------------------------------- #
# Function: Control
# Description: Calculate the transcriptional control array at time t
# Generated on: 2017-03-16T23:45:04.352
#
# Input arguments:
# t::Float64 => Current time value (scalar) 
# x::Array{Float64,1} => State array (number_of_species x 1) 
# data_dictionary::Dict{AbstractString,Any} => Dictionary holding model parameters 
#
# Output arguments:
# control_array::Array{Float64,1} => Transcriptional control array (number_of_genes x 1) at time t 
# ----------------------------------------------------------------------------------- #
function Control(t::Float64,x::Array{Float64,1},data_dictionary::Dict{AbstractString,Any})

	# initialize the control - 
	control_array = zeros(2)

	# Alias the species - 
	gene_1 = x[1]
	gene_system = x[2]
	mRNA_gene_1 = x[3]
	mRNA_gene_system = x[4]
	protein_gene_1 = x[5]
	protein_gene_system = x[6]

	# Alias the binding parameters - 
	binding_parameter_dictionary = data_dictionary["binding_parameter_dictionary"]
	n_gene_1_gene_system = binding_parameter_dictionary["n_gene_1_gene_system"]
	K_gene_1_gene_system = binding_parameter_dictionary["K_gene_1_gene_system"]

	# Alias the control function parameters - 
	control_parameter_dictionary = data_dictionary["control_parameter_dictionary"]
	W_gene_1_RNAP = control_parameter_dictionary["W_gene_1_RNAP"]
	W_gene_1_gene_system = control_parameter_dictionary["W_gene_1_gene_system"]
	W_gene_system_RNAP = control_parameter_dictionary["W_gene_system_RNAP"]

	# Transfer function target:gene_1 actor:gene_system
	actor_set_gene_1_gene_system = [
		protein_gene_system
	]
	actor = prod(actor_set_gene_1_gene_system)
	b_gene_1_gene_system = (actor^(n_gene_1_gene_system))/(K_gene_1_gene_system^(n_gene_1_gene_system)+actor^(n_gene_1_gene_system))

	# Control function for gene_1 - 
	control_array[1] = (W_gene_1_RNAP+W_gene_1_gene_system*b_gene_1_gene_system)/(1+W_gene_1_RNAP+W_gene_1_gene_system*b_gene_1_gene_system)

	# Control function for gene_system - 
	control_array[2] = (W_gene_system_RNAP)/(1+W_gene_system_RNAP)

	# return - 
	return control_array
end
