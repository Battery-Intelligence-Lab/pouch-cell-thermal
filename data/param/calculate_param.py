# -*- coding: utf-8 -*-
"""
Created on Wed Sep 25 17:34:11 2024

@author: Volkan Kumtepeli
"""

p = {}; unit = {}; explanation = {}

def add(name, val, un, exp):
    p[name]             = val
    unit[name]          = un
    explanation[name]   = exp
    
    
add('rp_pos',   	5e-6,   	'[m]',      	'Positive electrode particle radius')
add('rp_neg',   	5e-6,   	'[m]',      	'Negative electrode particle radius')
add('Ds',       	262e-16,	'[m^2/s]',  	'Solid diffusion')
add('kappa',    	55,     	'[S/m]',    	'Reference ionic conductivity')
add('i0ref',    	24,     	'[A/m^2]',  	'Exch current dens at T0')
add('Ei0',      	28.75,  	'[kJ/mol]', 	'Activation energy of (current)')
add('alfa_ka',  	2.4,    	'[S/m/K]',  	'Temperature coefficient for kappa')

add('C_rate',   	10.0,   	'[h]',      	'C-rate during simulation')
add('cl0',      	1.2,    	'[mol/l]',  	'Initial electrolyte concentration')

add('cp_el',    	859.2,  	'[J/kg/K]', 	'Specific heat of electrode')
add('cp_sep',   	1400,   	'[J/kg/K]', 	'Specific heat of separator')

add('epsl_neg', 	0.5,    	'[-]',      	'Anode porosity')
add('epsl_pos', 	0.5,    	'[-]',      	'Cathode porosity')
add('epss_neg', 	0.5,    	'[-]',      	'Solid phase in anode (volume fraction)')
add('epss_pos', 	0.5,    	'[-]',      	'Solid phase in cathode (volume fraction)')

add('H_bar',    	152e-3, 	'[m]',      	'Bar length (G)')
add('H_cell',   	195e-3, 	'[m]',      	'Cell length(G)') 
add('H_tab',    	50e-3,  	'[m]',      	'Negative tab length (G)')

add('Itab',     	10e-3,  	'[m]',      	'Tab distance')
add('Q_cell',   	9.0,    	'[Ah]',     	'Charge capacity')

add('N',        	26*2,   	'[-]',      	'Number of cell layers')

add('L_neg',    	p['N']*17.5e-6,     	'[m]',	'Negative electrode thickness (G)')
add('L_neg_cc', 	(p['N']/2)*10.67e-6,	'[m]',	'Negative current collector thickness (G)')
add('L_pos',    	p['N']*31.83e-6,    	'[m]',	'Positive electrode thickness (G)')
add('L_pos_cc', 	(p['N']/2)* 18.33e-6,	'[m]',	'Positive current collector thickness (G)')
add('L_sep',    	p['N']*13.67e-6,    	'[m]',	'Separator thickness (G)')
add('L_tab',    	p['L_pos_cc'],      	'[m]',	'Tab thickness (G - simplified for simulation meshing)')
add('L_bar',    	3.25e-3,            	'[m]',	'Bar thickness (G)')
add('L_cell',   	p['L_sep']+p['L_pos']+p['L_neg']+p['L_neg_cc']+p['L_pos_cc'],	'[m]',	'Cell thickness')

add('W_cell',   	145e-3, 	'[m]',      	'Cell width (G)')
add('W_tab',    	45e-3,  	'[m]',      	'Negative tab width (G)')

add('A_tab',    	p['W_tab']*p['L_bar'],	'[m^2]',	'Tab area')
add('Iapp',     	p['C_rate']*p['Q_cell']/p['A_tab'],	'[A/m^2]',	'Applied current')

add('k_cc',     	169.44, 	'[W/m/K]',  	'Thermal conductivity of cc')
add('k_sep',    	0.2,    	'[W/m/K]',  	'Thermal conductivity of separator')


add('rho_el',   	3000,   	'[kg/m^3]', 	'Electrode density')
add('rho_sep',  	1200,   	'[kg/m^3]', 	'Separator density')

add('sigma',    	50.0,   	'[S/m]',    	'Electrical conductivity')
add('sigma_al', 	4e7,    	'[S/m]',    	'Electrical conductivity of al')
add('sigma_cc', 	1e7,    	'[S/m]',    	'Electrical conductivity of cc')
add('sigma_cu', 	4e7,    	'[S/m]',    	'Electrical conductivity of cu')

add('x0',       	1,      	'[-]',      	'Initial Negative Electrode SOC')
add('y0',       	0,      	'[-]',      	'Initial Positive Electrode SOC')

add('Rho',      	2300,   	'[kg/m^3]', 	'Electrode density')
add('T0',       	20.95-0.15,	'[degC]',   	'Initial temperature')
add('Cp',       	1100,   	'[J/kg/K]', 	'Electrode specific heat')
add('k',        	26,     	'[W/m/K]',  	'kx optimised isotropic k')
add('ha',       	7.5,    	'[W/(m^2*K)]',	'Heat transfer coefficient')
add('ku',       	0.25,   	'[V]',      	'Slope of OCV curve')
add('sigma_tab',	1,      	'[-]',      	'')

add('difftime', 	p['rp_neg']**2/p['Ds'],	'[-]',	'')
add('ratio',    	p['ha']/p['Cp']*1e3,	'[-]',	'')
add('entropy',  	-2.8e-4,	'[V/K]',    	'entropy')
add('U0',       	3.6,    	'[V]',      	'')