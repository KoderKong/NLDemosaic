# NLDemosaic
Nonlinear demosaicking method and apparatus for nonlinear CMOS image sensors exhibiting low-density salt-and-pepper noise

# MATLAB algorithms
Clone the repository and change your path to the 'method' folder. Run a script, 'RGBtest.m', to recreate a data file, 'RGBtest.mat', used by another script, 'RGBplot.m', to produce Figures 6 to 8 (graphs) of the Hussain et al. paper [1]. An additional script, 'RGBtest1.m', may be used to produce the parts of Figure 9 (images). The scripts make use of algorithms proposed in the paper. Algorithms are available as several functions, e.g., nldemosaic2.m, in the same folder.

# Simulink models
Clone the repository and change your path to the 'apparatus' folder. Run the script, 'NLD2sim.m', to test a Simulink model, 'NLD2.slx', that is a realistic representation of the nonlinear demosaicking 2 (NLD2) digital circuit proposed in the Hussain et al. paper [2]. The folder contains additional test scripts and Simulink models, which represent circuits for variants proposed in the paper. Some models, e.g., 'median8.slx', are key subsystems of other models.

# See also
[1] Syed Hussain, Maikon Nascimento, and Dileepan Joseph, "Nonlinear demosaicking method and apparatus for nonlinear CMOS image sensors exhibiting low-density salt-and-pepper noise," SPIE Journal of Electronic Imaging, vol. 32, no. 2, pp. 023004-1–17, Mar. 2023 (https://doi.org/10.1117/1.JEI.32.2.023004).
