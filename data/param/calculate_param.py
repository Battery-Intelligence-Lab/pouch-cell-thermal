# -*- coding: utf-8 -*-
"""
Created on Wed Sep 25 17:34:11 2024

@author: Volkan Kumtepeli
"""

param = {}, unit = {}, explanation = {}

def add(name, val, un, exp):
    param[name]         = val
    unit[name]          = un
    explanation[name]   = exp
    
    
add('C_rate',   10.0,   '[h]',      'C-rate during simulation')
add('cl0',      1.2,    '[mol/l]',  'Initial electrolyte concentration')

add('cp_el',    859.2,  '[J/kg/K]',  'Specific heat of electrode')
add('cp_sep',   1400,   '[J/kg/K]',  'Specific heat of separator')


add('epsl_neg',   0.5,   '[-]',  'Anode porosity')
add('epsl_pos',   0.5,   '[-]',  'Cathode porosity')
add('epss_neg',   0.5,   '[-]',  'Solid phase in anode')
add('epss_pos',   0.5,   '[-]',  'Solid phase in cathode')

add('H_bar' ,   152.0/1000,  '[m]',  'Bar length (G)')
add('H_cell',   195.0/1000,  '[m]',  'Cell length(G)') 
add('H_tab',    50.0/1000,   '[m]',  'Negative tab length (G)')


add('Itab', 10/1000, '[m]', 'Tab distance')


add('C_rate',        '-10',                                     '[-]',                        'C-rate during simulation')
add('cl0',           '1.2[mol/l]',                             '[mol/l]',                    'Initial Electrolyte concentration')
add('cp_el',         '859.2 [J/kg/K]',                          '[J/kg/K]',                  'Specific heat of electrode')
add('cp_sep',        '1400 [J/kg/K]',                           '[J/kg/K]',                  'Specific heat of separator')

add('epsl_neg',      '0.5',                                     '[-]',                        'Anode porosity')
add('epsl_pos',      '0.5',                                     '[-]',                        'Cathode porosity')
add('epss_neg',      '0.5',                                     '[-]',                        'Solid phase in anode')
add('epss_pos',      '0.5',                                     '[-]',                        'Solid phase in cathode')

add('H_bar',         '152[mm]',                                 '[mm]',                       'Bar length (G)')
add('H_cell',        '195 [mm]',                                '[mm]',                       'Cell length(G)')
add('H_tab',         '50 [mm]',                                 '[mm]',                       'Negative tab length (G)')

add('I_1C',          'Q_cell/1[h]/W_tab/L_bar',                 '[A]',                        '1C current')
add('Iapp',          'I_1C*C_rate',                             '[A]',                        'Applied current')
add('Itab',          '10 [mm]',                                 '[mm]',                       'Tab distance')

add('k_cc',          '169.44 [W/m/K]',                          '[W/m/K]',                    'Thermal conductivity of cc')
add('k_sep',         '0.2 [W/m/K]',                             '[W/m/K]',                    'Thermal conductivity of separator')

add('L_bar',         '3.25 [mm]',                               '[mm]',                       'Bar thickness (G)')
add('L_cell',        'L_sep+L_pos+L_neg+L_neg_cc+L_pos_cc',     '[mm]',                       'Cell thickness (doesnt seem right)')
add('L_neg',         '17.5[um]*N',                              '[um]',                       'Negative electrode thickness (G)')
add('L_neg_cc',      '10.67 [um]*N/2',                          '[um]',                       'Negative current collector thickness (G)')
add('L_pos',         '31.83[um]*N',                             '[um]',                       'Positive electrode thickness (G)')
add('L_pos_cc',      '18.33 [um]*N/2',                          '[um]',                       'Positive current collector thickness (G)')
add('L_sep',         '13.67 [um]*N',                            '[um]',                       'Separator thickness (G)')
add('L_tab',         'L_pos_cc',                                '[um]',                       'Tab thickness (G - simplified for simulation meshing)')

add('N',             '26*2',                                    '[-]',                        'Number of cell layers')
add('Q_cell',        '9[Ah]',                                   '[Ah]',                       'Charge capacity')

add('rho_el',        '3000 [kg/m^3]',                           '[kg/m^3]',                   'Electrode density')
add('rho_sep',       '1200 [kg/m^3]',                           '[kg/m^3]',                   'Separator density')

add('sigma',         '50 [S/m]',                                '[S/m]',                      'Electrical conductivity')
add('sigma_al',      '4e7 [S/m]',                               '[S/m]',                      'Electrical conductivity of cc')
add('sigma_cc',      '1e7 [S/m]',                               '[S/m]',                      'Electrical conductivity of cc')
add('sigma_cu',      '4e7 [S/m]',                               '[S/m]',                      'Electrical conductivity of cc')

add('W_cell',        '145 [mm]',                                '[mm]',                       'Cell width (G)')
add('W_tab',         '45 [mm]',                                 '[mm]',                       'Negative tab width (G)')

add('x0',            '1',                                       '[-]',                        'Initial Negative Electrode SOC')
add('y0',            '0',                                       '[-]',                        'Initial Positive Electrode SOC')

add('Rho',           '2300 [kg/m^3]',                           '[kg/m^3]',                   'Electrode density')
add('T0',            '20.95[degC]-0.15',                        '[degC]',                     'Initial temperature')
add('Cp',            '1100[J/kg/K]',                            '[J/kg/K]',                   'Electrode specific heat')
add('k',             '26[W/m/K]',                               '[W/m/K]',                    'kx optimised isotropic k')
add('ha',            '7.5[W/(m^2*K)]',                           '[W/(m^2*K)]',                'Heat transfer coefficient')
add('ku',            '0.25[V]',                                 '[V]',                        'Slope of OCV curve')
add('sigma_tab',     '1',                                       '[-]',                        '')

add('difftime',      'rp_neg^2/Ds',                             '[-]',                        '')
add('ratio',         'ha/Cp*1e3',                               '[-]',                        '')
add('entropy',       '-2.8e-4 [V/K]',                           '[V/K]',                      'entropy')
add('U0',            '3.6[V]',                                  '[V]',                        '')

add('rp_pos',        '5 [um]',                                  '[um]',                       'Positive electrode particle radius')
add('rp_neg',        '5 [um]',                                  '[um]',                       'Negative electrode particle radius')
add('Ds',            '262e-16[m^2/s]',                           '[m^2/s]',                    '')
add('kappa',         '55[S/m]',                                 '[S/m]',                      'Reference ionic conductivity')
add('i0ref',         '24[A/m^2]',                               '[A/m^2]',                    'Exch current dens at T0')
add('Ei0',           '28.75[kJ/mol]',                           '[kJ/mol]',                   'Activation energy of (current)')
add('alfa_ka',       '2.4[S/m/K]',                              '[S/m/K]',                    'Temperature coefficient for kappa')