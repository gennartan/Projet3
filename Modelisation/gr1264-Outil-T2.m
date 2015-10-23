function [ T_i T_max CH4 O2 N2 H2O CO2 CO H2 NH3]  = main(m_CH4, R_O2_CH4, R_H2O_CH4, T_ATR, p_ATR)
%MAIN Simule le procédé de synthèse de l'ammoniac avec les paramètres
%     donnés en entrée. Une interface graphique est aussi disponible pour
%     l'utilisateur. Le détail des calculs effectués sont disponibles dans
%     notre rapport de gestion de la production rendu le 16/10/2015
%     V1.0 -23/10/2015- Groupe 1264, Membres:
%       Paul Asselberghs, Brice Bertin, Adrien Couplet, Grégory Creupelandt
%       Anthony Gatin, Antoine Gennart, Juline Gillard, Pierre Martin
%   === INPUT ===
%       m_CH4     : le débit d'alimentation de CH4 [t/j]
%       R_O2_CH4  : Rapport O2/CH4 à l'entrée de l'ATR 
%       R_H2O_CH4 : Rapport H2O/CH4 à l'entrée de l'ATR
%       T_ATR     : Température à la sortie de la zone de reforming (ATR) [K]
%       p_ATR     : La pression d'opération de l'ATR [bar]
%   
%   === OUTPUT ===
%       T_i : Température à l'entrée de l'ATR [K]
%       T_max : Température maximale dans la zone de combustion [K]
%       Le reste du output sont des vecteurs exprimant l'évolution du débit
%       d'un réactif à différentes étapes du procédé. L'unité par défaut
%       est [mol/s].
%           CH4(1) : après l'air separation unit
%           CH4(2) : après la zone de combustion
%           CH4(3) : après la zone de reformage
%           CH4(4) : après le water-gas-shift
%           CH4(5) : après la condensation/absorption
%           CH4(6) : après la synthèse de l'ammoniac
%   
    
    %% Variables Globales
    % On utilise des variables globales afin que celles-ci soient
    % accessibles et modifiables n'importe où dans le programme. 
    global fig titl results params params1_1 params1_2 params1_3 params2_1 params2_2 params2_3 params3_1 params3_2 params3_3 params4_1 params4_2 params4_3 params5_1 params5_2 params5_3;
    global totaux totaux1_1 totaux1_2 totaux1_3 totaux2_1 totaux2_2 totaux2_3 totaux3_1 totaux3_2 totaux3_3 totaux4_1 totaux4_2 totaux4_3 totaux5_1 totaux5_2 totaux5_3 totaux6_1 totaux6_2 totaux6_3 totaux7_1 totaux7_2 totaux7_3 totaux8_1 totaux8_2 totaux8_3 totaux9_1 totaux9_2 totaux9_3 totaux10_1 totaux10_2 totaux10_3;
    global asu asu1_1 asu1_2 asu1_3 asu2_1 asu2_2 asu2_3 asu3_1 asu3_2 asu3_3 asu4_1 asu4_2 asu4_3;
    global comb comb1_1 comb1_2 comb1_3 comb2_1 comb2_2 comb2_3 comb3_1 comb3_2 comb3_3 comb4_1 comb4_2 comb4_3 comb5_1 comb5_2 comb5_3 comb6_1 comb6_2 comb6_3 comb7_1 comb7_2 comb7_3 comb8_1 comb8_2 comb8_3 comb9_1 comb9_2 comb9_3;
    global reform reform1_1 reform1_2 reform1_3 reform2_1 reform2_2 reform2_3 reform3_1 reform3_2 reform3_3 reform4_1 reform4_2 reform4_3 reform5_1 reform5_2 reform5_3 reform6_1 reform6_2 reform6_3 reform7_1 reform7_2 reform7_3 reform8_1 reform8_2 reform8_3 reform9_1 reform9_2 reform9_3 reform10_1 reform10_2 reform10_3 reform11_1 reform11_2 reform11_3 reform12_1 reform12_2 reform12_3;
    global wgs wgs1_1 wgs1_2 wgs1_3 wgs2_1 wgs2_2 wgs2_3 wgs3_1 wgs3_2 wgs3_3 wgs4_1 wgs4_2 wgs4_3 wgs5_1 wgs5_2 wgs5_3 wgs6_1 wgs6_2 wgs6_3 wgs7_1 wgs7_2 wgs7_3 wgs8_1 wgs8_2 wgs8_3;
    global conabs conabs1_1 conabs1_2 conabs1_3 conabs2_1 conabs2_2 conabs2_3;
    global synth synth1_1 synth1_2 synth1_3 synth2_1 synth2_2 synth2_3 synth3_1 synth3_2 synth3_3 synth4_1 synth4_2 synth4_3 synth5_1 synth5_2 synth5_3 synth6_1 synth6_2 synth6_3;
    global btn_simul panel_select panel_text units_select units_text;
    global plotpanel plot_text plot1 plot2 plot3 plot4 plot5 plot6 plot7 plot8 plot_btn; 
    global R_O2_Air R_N2_Air SecPerDay;
    global M_Air M_CH4 M_CO M_CO2 M_H2 M_H2O M_N2 M_NH3 M_O2;
    global n_CH4 n_O2 n_H2O n_Air n_N2 n_CO2 n_CO n_H2 n_NH3;
    global dH_CH4 dH_SMR dH_WGS dH_comb dH_reform c m_tot;
    global currentUnits;
    
    %% Variables constantes
    R_O2_Air = 0.21; R_N2_Air = 0.79; % Composition de l'air
    SecPerDay = 86400; % Nombre de secondes par jour [s/jour]
    M_O2  = 32.0; M_N2  = 28.0; M_H2O = 18.0; M_CH4 = 16.0; M_CO2 = 44.0; M_CO  = 28.0; M_H2  = 2.0 ; M_NH3 = 17.0; M_Air = 28.97; % Masses molaires [g/mol]
    dH_CH4 = -803000; dH_SMR = 224000; dH_WGS = -37300; % Variation d'enthalpie [J/mol]
    c = 2500; % Capacité thermique [J/kgK]
    currentUnits = 1; % Unité utilisé [mol/s]
    
    function createGui()
    %% CREATEGUI Crée l'interface graphique du programme, chaque
     %              élément est une variable globale qui pourra être
     %              modifiée pendant l'exécution du programme.
        fig = figure('Visible','off','Position',[100,100,800,500],'Name','Gestion de la production d''ammoniac Groupe 1264','ToolBar','none','MenuBar','none','NumberTitle','off');
        titl  = uicontrol('Style','text','Fontsize',20,'String','Gestion de la production d''ammoniac','Position',[0,470,800,30]);
        params = uipanel('Parent',fig,'Title','Paramètres','FontSize',12,'FontWeight','bold','Visible','on','Units','pixels','Position',[5, 340,350,130]);
            params1_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''alimentation de CH4','HorizontalAlignment','left','Position',[5,90,250,15]);
            params1_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,90,50,15]);
            params1_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','t/j','HorizontalAlignment','right','Position',[305,90,40,15]);
            params2_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Rapport O2/CH4 à l''entrée de l''ATR','HorizontalAlignment','left','Position',[5,70,250,15]);
            params2_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,70,50,15]);
            params2_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','','HorizontalAlignment','right','Position',[305,70,40,15]);
            params3_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Rapport H2O/CH4 à l''entrée de l''ATR','HorizontalAlignment','left','Position',[5,50,250,15]);
            params3_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,50,50,15]);
            params3_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','','HorizontalAlignment','right','Position',[305,50,40,15]);
            params4_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Température à la sortie de l''ATR','HorizontalAlignment','left','Position',[5,30,250,15]);
            params4_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,30,50,15]);
            params4_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[305,30,40,15]);
            params5_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Pression d''opération de l''ATR','HorizontalAlignment','left','Position',[5,10,250,15]);
            params5_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,10,50,15]);
            params5_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','bar','HorizontalAlignment','right','Position',[305,10,40,15]);
        results = uipanel('Parent',fig,'Title','Résultats','FontSize',12,'FontWeight','bold','Visible','on','Units','pixels','Position',[360, 5,435,465]);
            totaux = uipanel('Parent',results,'Title','Totaux','FontSize',9,'FontWeight','bold','Visible','on','Units','pixels','Position',[5, 5,425,440]);
                totaux1_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée Air','HorizontalAlignment','left','Position',[5,400,275,15]);
                totaux1_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                totaux1_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                totaux2_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CH4','HorizontalAlignment','left','Position',[5,380,275,15]);
                totaux2_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                totaux2_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);
                totaux3_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2O','HorizontalAlignment','left','Position',[5,360,275,15]);
                totaux3_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,360,100,15]);
                totaux3_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,360,40,15]);

                totaux4_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CH4','HorizontalAlignment','left','Position',[5,320,275,15]);
                totaux4_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,320,100,15]);
                totaux4_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,320,40,15]);
                totaux5_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2O','HorizontalAlignment','left','Position',[5,300,275,15]);
                totaux5_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                totaux5_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);
                totaux6_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO2','HorizontalAlignment','left','Position',[5,280,275,15]);
                totaux6_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,280,100,15]);
                totaux6_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,280,40,15]);
                totaux7_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie N2','HorizontalAlignment','left','Position',[5,260,275,15]);
                totaux7_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,260,100,15]);
                totaux7_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,260,40,15]);
                totaux8_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie NH3','HorizontalAlignment','left','Position',[5,240,275,15]);
                totaux8_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,240,100,15]);
                totaux8_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,240,40,15]);

                totaux9_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Température d''entrée dans l''ATR','HorizontalAlignment','left','Position',[5,200,275,15]);
                totaux9_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,200,100,15]);
                totaux9_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,200,40,15]);
                totaux10_1 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','Température maximale (combustion)','HorizontalAlignment','left','Position',[5,180,275,15]);
                totaux10_2 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,180,100,15]);
                totaux10_3 = uicontrol('Parent',totaux,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,180,40,15]);
            asu    = uipanel('Parent',results,'Title','Air Separation Unit','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                asu1_1 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée Air','HorizontalAlignment','left','Position',[5,400,275,15]);
                asu1_2 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                asu1_3 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);

                asu2_1 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie O2','HorizontalAlignment','left','Position',[5,360,275,15]);
                asu2_2 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,360,100,15]);
                asu2_3 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,360,40,15]);
                asu3_1 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie N2','HorizontalAlignment','left','Position',[5,340,275,15]);
                asu3_2 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,340,100,15]);
                asu3_3 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,340,40,15]);
                
                asu4_1 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','Excès N2','HorizontalAlignment','left','Position',[5,300,275,15]);
                asu4_2 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                asu4_3 = uicontrol('Parent',asu,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);
            comb   = uipanel('Parent',results,'Title','Autothermal Reformer (ATR) : Combustion','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                comb1_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CH4','HorizontalAlignment','left','Position',[5,400,275,15]);
                comb1_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                comb1_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                comb2_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée O2','HorizontalAlignment','left','Position',[5,380,275,15]);
                comb2_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                comb2_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);
                comb3_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2O','HorizontalAlignment','left','Position',[5,360,275,15]);
                comb3_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,360,100,15]);
                comb3_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,360,40,15]);

                comb4_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CH4','HorizontalAlignment','left','Position',[5,320,275,15]);
                comb4_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,320,100,15]);
                comb4_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,320,40,15]);
                comb5_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie O2','HorizontalAlignment','left','Position',[5,300,275,15]);
                comb5_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                comb5_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);
                comb6_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO2','HorizontalAlignment','left','Position',[5,280,275,15]);
                comb6_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,280,100,15]);
                comb6_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,280,40,15]);
                comb7_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2O','HorizontalAlignment','left','Position',[5,260,275,15]);
                comb7_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,260,100,15]);
                comb7_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,260,40,15]);

                comb8_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Température d''entrée dans l''ATR','HorizontalAlignment','left','Position',[5,220,275,15]);
                comb8_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,220,100,15]);
                comb8_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,220,40,15]);
                comb9_1 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','Température maximale (combustion)','HorizontalAlignment','left','Position',[5,200,275,15]);
                comb9_2 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,200,100,15]);
                comb9_3 = uicontrol('Parent',comb,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,200,40,15]);
            reform = uipanel('Parent',results,'Title','Autothermal Reformer (ATR) : Reformage','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                reform1_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CH4','HorizontalAlignment','left','Position',[5,400,275,15]);
                reform1_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                reform1_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                reform2_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2O','HorizontalAlignment','left','Position',[5,380,275,15]);
                reform2_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                reform2_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);
                reform3_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CO2','HorizontalAlignment','left','Position',[5,360,275,15]);
                reform3_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,360,100,15]);
                reform3_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,360,40,15]);

                reform4_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Solution du premier équilibre','HorizontalAlignment','left','Position',[5,320,275,15]);
                reform4_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,320,100,15]);
                reform4_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,320,40,15]);
                reform5_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Solution du deuxième équilibre','HorizontalAlignment','left','Position',[5,300,275,15]);
                reform5_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                reform5_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);

                reform6_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CH4','HorizontalAlignment','left','Position',[5,260,275,15]);
                reform6_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,260,100,15]);
                reform6_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,260,40,15]);
                reform7_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2O','HorizontalAlignment','left','Position',[5,240,275,15]);
                reform7_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,240,100,15]);
                reform7_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,240,40,15]);
                reform8_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO2','HorizontalAlignment','left','Position',[5,220,275,15]);
                reform8_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,220,100,15]);
                reform8_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,220,40,15]);
                reform9_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO','HorizontalAlignment','left','Position',[5,200,275,15]);
                reform9_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,200,100,15]);
                reform9_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,200,40,15]);
                reform10_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2','HorizontalAlignment','left','Position',[5,180,275,15]);
                reform10_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,180,100,15]);
                reform10_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,180,40,15]);

                reform11_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Température de la zone de reformage','HorizontalAlignment','left','Position',[5,140,275,15]);
                reform11_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,140,100,15]);
                reform11_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,140,40,15]);
                reform12_1 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','Pression d''opération (ATR)','HorizontalAlignment','left','Position',[5,120,275,15]);
                reform12_2 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,120,100,15]);
                reform12_3 = uicontrol('Parent',reform,'Style','text','BackgroundColor',[1 1 1],'String','K','HorizontalAlignment','right','Position',[380,120,40,15]);
            wgs    = uipanel('Parent',results,'Title','Water Gas Shift','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                wgs1_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CO','HorizontalAlignment','left','Position',[5,400,275,15]);
                wgs1_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                wgs1_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                wgs2_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2O','HorizontalAlignment','left','Position',[5,380,275,15]);
                wgs2_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                wgs2_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);
                wgs3_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée CO2','HorizontalAlignment','left','Position',[5,360,275,15]);
                wgs3_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,360,100,15]);
                wgs3_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,360,40,15]);
                wgs4_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2','HorizontalAlignment','left','Position',[5,340,275,15]);
                wgs4_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,340,100,15]);
                wgs4_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,340,40,15]);

                wgs5_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO','HorizontalAlignment','left','Position',[5,300,275,15]);
                wgs5_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                wgs5_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);
                wgs6_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2O','HorizontalAlignment','left','Position',[5,280,275,15]);
                wgs6_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,280,100,15]);
                wgs6_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,280,40,15]);
                wgs7_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CO2','HorizontalAlignment','left','Position',[5,260,275,15]);
                wgs7_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,260,100,15]);
                wgs7_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,260,40,15]);
                wgs8_1 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2','HorizontalAlignment','left','Position',[5,240,275,15]);
                wgs8_2 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,240,100,15]);
                wgs8_3 = uicontrol('Parent',wgs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,240,40,15]);
            conabs = uipanel('Parent',results,'Title','Condensation & Absorption','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                conabs1_1 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[1 1 1],'String','Débit retiré H2O','HorizontalAlignment','left','Position',[5,400,275,15]);
                conabs1_2 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                conabs1_3 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                conabs2_1 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[1 1 1],'String','Débit retiré CO2','HorizontalAlignment','left','Position',[5,380,275,15]);
                conabs2_2 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                conabs2_3 = uicontrol('Parent',conabs,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);
            synth  = uipanel('Parent',results,'Title','Synthèse de l''ammoniac','FontSize',9,'FontWeight','bold','Visible','off','Units','pixels','Position',[5, 5,425,440]);
                synth1_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée H2','HorizontalAlignment','left','Position',[5,400,275,15]);
                synth1_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,400,100,15]);
                synth1_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,400,40,15]);
                synth2_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''entrée N2','HorizontalAlignment','left','Position',[5,380,275,15]);
                synth2_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,380,100,15]);
                synth2_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,380,40,15]);

                synth3_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie H2','HorizontalAlignment','left','Position',[5,340,275,15]);
                synth3_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,340,100,15]);
                synth3_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,340,40,15]);
                synth4_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie N2','HorizontalAlignment','left','Position',[5,320,275,15]);
                synth4_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,320,100,15]);
                synth4_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,320,40,15]);
                synth5_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie NH3','HorizontalAlignment','left','Position',[5,300,275,15]);
                synth5_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,300,100,15]);
                synth5_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,300,40,15]);
                synth6_1 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','Débit de sortie CH4','HorizontalAlignment','left','Position',[5,280,275,15]);
                synth6_2 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[.8 .8 .8],'String','FILL','HorizontalAlignment','center','Position',[280,280,100,15]);
                synth6_3 = uicontrol('Parent',synth,'Style','text','BackgroundColor',[1 1 1],'String','mol/s','HorizontalAlignment','right','Position',[380,280,40,15]);

        btn_simul = uicontrol('Style','pushbutton','BackgroundColor',[0.2 0.6 1],'String','Simuler','FontSize',12,'FontWeight','bold','HorizontalAlignment','center','Callback',@simulate,'Position',[15,310,330,25]);
        panel_text   = uicontrol('Style','text','BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Sélectionnez une unité opérationelle :','Position',[15,275,330,15]);
        panel_select = uicontrol('Style','popupmenu','String', {'Totaux','Air Separation Unit','ATR : combustion','ATR : reformage','Water Gas Shift','Condensation/Absorption','Synthèse de l''ammoniac'},'Callback', @setpanel,'Position',[15,250,330,25]);
        units_text   = uicontrol('Style','text','BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Sélectionnez l''unité désirée :','Position',[15,225,330,15]);
        units_select = uicontrol('Style','popupmenu','String', {'mol/s','kg/s','t/j'},'Callback',@setunit,'Position',[15,200,330,25]);
        plotpanel = uipanel('Parent',fig,'Title','Graphe','FontSize',12,'FontWeight','bold','Visible','on','Units','pixels','Position',[5, 5,350,190]);
            plot_text = uicontrol('Style','text','Parent',plotpanel,'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Sélectionnez les réactifs :','Position',[10,140,200,15]);
            plot1     = uicontrol('Style','checkbox','Parent',plotpanel,'String','CH4','Value',0,'Position',[10, 120, 100, 20]);
            plot2     = uicontrol('Style','checkbox','Parent',plotpanel,'String','O2','Value',0,'Position',[10, 100, 100, 20]);
            plot3     = uicontrol('Style','checkbox','Parent',plotpanel,'String','N2','Value',0,'Position',[10, 80, 100, 20]);
            plot4     = uicontrol('Style','checkbox','Parent',plotpanel,'String','H2O','Value',0,'Position',[10, 60, 100, 20]);
            plot5     = uicontrol('Style','checkbox','Parent',plotpanel,'String','CO2','Value',0,'Position',[110, 120, 100, 20]);
            plot6     = uicontrol('Style','checkbox','Parent',plotpanel,'String','CO','Value',0,'Position',[110, 100, 100, 20]);
            plot7     = uicontrol('Style','checkbox','Parent',plotpanel,'String','H2','Value',0,'Position',[110, 80, 100, 20]);
            plot8     = uicontrol('Style','checkbox','Parent',plotpanel,'String','NH3','Value',0,'Position',[110, 60, 100, 20]);
            plot_btn  = uicontrol('Style','pushbutton','Parent',plotpanel,'String','Plot','FontSize',12,'FontWeight','bold','HorizontalAlignment','center','Callback',@plotReactif,'Position',[150,30,180,25]);
        set(fig,'Visible','on');
    end 

    function preprocess()
    %% PREPROCESS Calculs avant le début du procédé.
     %               Calcule les variables qui peuvent déjà l'être.
     %               Rempli l'interface graphique de ce qui a déjà pu être
     %               calculé.
        % Tous les calculs avant le début du procédé
        n_CH4 = m_CH4*(10^6)/M_CH4/SecPerDay;
        n_O2  = R_O2_CH4 * n_CH4;
        n_H2O = R_H2O_CH4 * n_CH4;
        n_Air = n_O2 / R_O2_Air;
        n_N2 = n_Air * R_N2_Air;
        CH4(1) = n_CH4;
        O2(1) = n_O2;
        N2(1) = n_N2;
        H2O(1) = n_H2O;
        CO2(1) = 0;
        CO(1) = 0;
        H2(1) = 0;
        NH3(1) = 0;
        
        % Rempli l'interface graphique
        set(params1_2,'String',m_CH4);
        set(params2_2,'String',R_O2_CH4);
        set(params3_2,'String',R_H2O_CH4);
        set(params4_2,'String',T_ATR);
        set(params5_2,'String',p_ATR);
        set(totaux1_2,'String',n_Air);
        set(totaux2_2,'String',n_CH4);
        set(totaux3_2,'String',n_H2O);
        set(comb1_2,'String',n_CH4);
        set(comb2_2,'String',n_O2);
        set(comb3_2,'String',n_H2O);
        set(asu1_2,'String',n_Air);
        set(asu2_2,'String',n_O2);
        set(asu3_2,'String',n_N2);
    end
    function combustion()
    %% COMBUSTION Calculs dans la zone de combustion
     %               Calcule les variables qui peuvent déjà l'être.
     %               Rempli l'interface graphique de ce qui a déjà pu être
     %               calculé.
     %               CH4     +    2* O2     -->   CO2     +     2* H2O
     
        % Calculs dans la zone de combustion
        m_tot = ((n_O2*M_O2)+(n_CH4*M_CH4)+(n_H2O*M_H2O))/1000;
        n_reac = min(n_CH4, n_O2/2); % [mol/s] nombre de mol reagissant (par unité de mole de CO2 produite)
        n_O2 = n_O2 - 2*n_reac; % [mol/s]
        n_CH4 = n_CH4 - n_reac;
        n_H2O = n_H2O + 2*n_reac;
        n_CO2 = n_reac;
        dH_comb = dH_CH4 * n_reac;
        CH4(2) = n_CH4;
        O2(2) = n_O2;
        N2(2) = n_N2;
        H2O(2) = n_H2O;
        CO2(2) = n_CO2;
        CO(2) = 0;
        H2(2) = 0;
        NH3(2) = 0;
        
        % Rempli l'interface graphique
        set(comb4_2,'String',n_CH4);
        set(comb5_2,'String',n_O2);
        set(comb6_2,'String',n_CO2);
        set(comb7_2,'String',n_H2O);
        set(reform1_2,'String',n_CH4);
        set(reform2_2,'String',n_H2O);
        set(reform3_2,'String',n_CO2);
    end
    function reformage()
    %% REFORMAGE Calculs dans la zone de reformage
     %               Calcule les variables qui peuvent déjà l'être.
     %               Rempli l'interface graphique de ce qui a déjà pu être
     %               calculé.
     % 1e équilibre  CH4    +      H2O      <-->    3* H2    +    CO
     % 2e équilibre  CO     +      2* H2O   <-->    H2       +    CO2   
     
        % Constantes d'équilibre
        KSMR = 10^((-11650/T_ATR)+13.076);
        KWGS = 10^((1910/T_ATR)-1.764);
        % Resolution du systeme : 2 equations 2 inconnues
        function F = myfun(x)
    		F(1) = (((x(1)-x(2))*(3*x(1)+x(2))^3 * (p_ATR)^2) / ... 
    		       ((n_CH4+n_H2O+2*x(1)+n_CO2)^2 * (n_H2O-x(1)-x(2))*(n_CH4-x(1))))-KSMR;
    		F(2) = (((n_CO2+x(2))*(3*x(1)+x(2))) / ((x(1)-x(2))*(n_H2O-x(1)-x(2))))-KWGS;
        end
    	X0(1) = 0.8*n_CH4;
    	X0(2) = 0.05*n_CH4;
    	OPTIONS = optimoptions('fsolve', 'Display','none','MaxFunEvals', 1000);
    	X = fsolve(@myfun, X0, OPTIONS);
        % X(1) : degre d'avancement de la premiere reaction [mol/s]
        % X(2) : degre d'avancement de la seconde reaction [mol/s]
        
        n_CH4 = (n_CH4-X(1));
        n_H2O = (n_H2O-X(1)-X(2));
        n_H2 = (3*X(1)+X(2));
        n_CO = (X(1)-X(2));
        n_CO2 = (n_CO2+X(2));
        dH_reform = (dH_SMR*X(1))+(dH_WGS*X(2)); 
        T_i = ((dH_comb+dH_reform)+(c*m_tot*T_ATR))/(c*m_tot);
        T_max = ((-dH_comb)+(c*m_tot*T_i))/(c*m_tot);
        CH4(3) = n_CH4;
        O2(3) = n_O2;
        N2(3) = n_N2;
        H2O(3) = n_H2O;
        CO2(3) = n_CO2;
        CO(3) = n_CO;
        H2(3) = n_H2;
        NH3(3) = 0;
        
        % Rempli l'interface graphique
        set(comb8_2,'String',T_i);
        set(comb9_2,'String',T_max);
        set(reform4_2,'String',X(1));
        set(reform5_2,'String',X(2));
        set(reform6_2,'String',n_CH4);
        set(reform7_2,'String',n_H2O);
        set(reform8_2,'String',n_CO2);
        set(reform9_2,'String',n_CO);
        set(reform10_2,'String',n_H2);
        set(reform11_2,'String',T_ATR);
        set(reform12_2,'String',p_ATR);
        set(wgs1_2,'String',n_CO);
        set(wgs2_2,'String',n_H2O);
        set(wgs3_2,'String',n_CO2);
        set(wgs4_2,'String',n_H2);
        set(synth6_2,'String',n_CH4);
        set(totaux4_2,'String',n_CH4);
        set(totaux9_2,'String',T_i);
        set(totaux10_2,'String',T_max);
    end
    function watergasshift()
    %% WATERGASSHIFT Calculs dans la réaction de WGS
     %               Calcule les variables qui peuvent déjà l'être.
     %               Rempli l'interface graphique de ce qui a déjà pu être
     %               calculé.
     %               CO     +     H2O    -->    H2     +   CO2
        n_reac=min(n_CO, n_H2O);
        n_H2O = n_H2O-n_reac;
        n_CO = n_CO-n_reac;
        n_H2 = n_H2+n_reac;
        n_CO2 = n_CO2+n_reac;
        CH4(4) = n_CH4; CH4(5) = n_CH4;
        O2(4) = n_O2; O2(5) = n_O2;
        N2(4) = n_N2; N2(5) = n_N2;
        H2O(4) = n_H2O; H2O(5) = 0;
        CO2(4) = n_CO2; CO2(5) = 0;
        CO(4) = n_CO; CO(5) = n_CO;
        H2(4) = n_H2; H2(5) = n_H2;
        NH3(4) = 0; NH3(5) = 0;
        
        % Rempli l'interface graphique
        set(wgs5_2,'String',n_CO);
        set(wgs6_2,'String',n_H2O);
        set(wgs7_2,'String',n_CO2);
        set(wgs8_2,'String',n_H2);
        set(conabs1_2,'String',n_H2O);
        set(conabs2_2,'String',n_CO2);
        set(totaux5_2,'String',n_H2O);
        set(totaux6_2,'String',n_CO2);
        set(synth1_2,'String',n_H2);
        set(synth2_2,'String',n_N2);
    end
    function synthese()
    %% SYNTHESE Calculs dans la réaction de synthèse
     %               Calcule les variables qui peuvent déjà l'être.
     %               Rempli l'interface graphique de ce qui a déjà pu être
     %               calculé.
     %               3* H2     +     N2     -->    2* NH3   
        n_reac=min(n_N2, n_H2/3);
        n_H2 = n_H2-3*n_reac;
        n_N2 = n_N2-n_reac; 
        n_NH3 = 2*n_reac;
        CH4(6) = n_CH4;
        O2(6) = n_O2;
        N2(6) = n_N2;
        H2O(6) = 0;
        CO2(6) = 0;
        CO(6) = n_CO;
        H2(6) = n_H2;
        NH3(6) = n_NH3;
        
        % Rempli l'interface graphique
        set(asu4_2,'String',n_N2);
        set(synth3_2,'String',n_H2);
        set(synth4_2,'String',n_N2);
        set(synth5_2,'String',n_NH3);
        set(totaux7_2,'String',n_N2);
        set(totaux8_2,'String',n_NH3);
    end

    function simulate(source,callbackdata)
    %% SIMULATE fonction de simulation
     %             Relance la fonction principale avec les paramètres de
     %             l'interface graphique..
        setunit(1,1);
        main(str2num(get(params1_2,'String')), ...
             str2num(get(params2_2,'String')), ...
             str2num(get(params3_2,'String')), ...
             str2num(get(params4_2,'String')), ...
             str2num(get(params5_2,'String')));
    end

     %===== Graphical Functions =====
    function setpanel(source,callbackdata)
    %% SETPANEL Sélection des panneaux d'informations.
        set(totaux,'Visible','off'); set(asu,'Visible','off'); set(comb,'Visible','off'); set(reform,'Visible','off'); set(wgs,'Visible','off'); set(conabs,'Visible','off'); set(synth,'Visible','off'); 
        switch(get(source,'Value'))
            case 1 
                set(totaux,'Visible','on');
            case 2
                set(asu,'Visible','on');
            case 3
                set(comb,'Visible','on');
            case 4
                set(reform,'Visible','on');
            case 5
                set(wgs,'Visible','on');
            case 6
                set(conabs,'Visible','on');
            case 7
                set(synth,'Visible','on');
            otherwise
                set(totaux,'Visible','on');
        end      
    end

    function setunit(source,callbackdata)
    %% SETUNIT Modifie les unités utilisées dans l'interface 
     %            graphique. Cette fonction est capable de convertir les
     %            unités [mol/s],[kg/s],[t/j] en [mol/s],[kg/s],[t/j]
        function OneS(ui)
            set(ui,'String','mol/s');
        end
        function TwoS(ui)
            set(ui,'String','kg/s');
        end
        function ThreeS(ui)
            set(ui,'String','t/j');
        end
        function OneTwo(ui, M)
            set(ui,'String',str2num(get(ui,'String'))*M/1000);
        end
        function OneThree(ui, M)
            set(ui,'String',str2num(get(ui,'String'))*M/1000/1000*SecPerDay);
        end
        function TwoOne(ui, M)
            set(ui,'String',str2num(get(ui,'String'))/M*1000);
        end
        function TwoThree(ui, M)
            set(ui,'String',str2num(get(ui,'String'))/1000*SecPerDay);
        end
        function ThreeOne(ui, M)
            set(ui,'String',str2num(get(ui,'String'))/M*1000*1000/SecPerDay);
        end
        function ThreeTwo(ui, M)
            set(ui,'String',str2num(get(ui,'String'))*1000/SecPerDay);
        end
        try
            if currentUnits == 1 && get(source,'Value') == 2 % [mol/s] ---> [kg/s]
                OneTwo(totaux1_2,M_Air); OneTwo(totaux2_2,M_CH4); OneTwo(totaux3_2,M_H2O); OneTwo(totaux4_2,M_CH4); OneTwo(totaux5_2,M_H2O); OneTwo(totaux6_2,M_CO2); OneTwo(totaux7_2,M_N2); OneTwo(totaux8_2,M_NH3);
                TwoS(totaux1_3); TwoS(totaux2_3); TwoS(totaux3_3); TwoS(totaux4_3); TwoS(totaux5_3); TwoS(totaux6_3); TwoS(totaux7_3); TwoS(totaux8_3); 
                OneTwo(asu1_2,M_Air); OneTwo(asu2_2,M_O2); OneTwo(asu3_2,M_N2); OneTwo(asu4_2,M_N2); 
                TwoS(asu1_3); TwoS(asu2_3); TwoS(asu3_3); TwoS(asu4_3); 
                OneTwo(comb1_2,M_CH4); OneTwo(comb2_2,M_O2); OneTwo(comb3_2,M_H2O); OneTwo(comb4_2,M_CH4); OneTwo(comb5_2,M_O2); OneTwo(comb6_2,M_CO2); OneTwo(comb7_2,M_H2O);
                TwoS(comb1_3); TwoS(comb2_3); TwoS(comb3_3); TwoS(comb4_3); TwoS(comb5_3); TwoS(comb6_3); TwoS(comb7_3)
                OneTwo(reform1_2,M_CH4); OneTwo(reform2_2,M_H2O); OneTwo(reform3_2,M_CO2); OneTwo(reform6_2,M_CH4); OneTwo(reform7_2,M_H2O); OneTwo(reform8_2,M_CO2); OneTwo(reform9_2,M_CO); OneTwo(reform10_2,M_H2);
                TwoS(reform1_3); TwoS(reform2_3); TwoS(reform3_3); TwoS(reform6_3); TwoS(reform7_3); TwoS(reform8_3); TwoS(reform9_3); TwoS(reform10_3); 
                OneTwo(wgs1_2,M_CO); OneTwo(wgs2_2,M_H2O); OneTwo(wgs3_2,M_CO2); OneTwo(wgs4_2,M_H2); OneTwo(wgs5_2,M_CO); OneTwo(wgs6_2,M_H2O); OneTwo(wgs7_2,M_CO2); OneTwo(wgs8_2,M_H2);
                TwoS(wgs1_3); TwoS(wgs2_3); TwoS(wgs3_3); TwoS(wgs4_3); TwoS(wgs5_3); TwoS(wgs6_3); TwoS(wgs7_3); TwoS(wgs8_3); 
                OneTwo(conabs1_2,M_H2O); OneTwo(conabs2_2,M_CO2); 
                TwoS(conabs1_3); TwoS(conabs2_3);
                OneTwo(synth1_2,M_H2); OneTwo(synth2_2,M_N2); OneTwo(synth3_2,M_H2); OneTwo(synth4_2,M_N2); OneTwo(synth5_2,M_NH3); OneTwo(synth6_2,M_CH4);
                TwoS(synth1_3); TwoS(synth2_3); TwoS(synth3_3); TwoS(synth4_3); TwoS(synth5_3); TwoS(synth6_3);
                CH4 = CH4*M_CH4/1000; O2 = O2*M_CO2/1000; N2 = N2*M_N2/1000; H2O = H2O*M_H2O/1000; CO2 = CO2*M_CO2/1000; CO = CO*M_CO/1000; H2 = H2*M_H2/1000; NH3 = NH3*M_NH3/1000;
                currentUnits = 2;
            elseif currentUnits == 1 && get(source,'Value') == 3 % [mol/s] ---> [t/j]
                OneThree(totaux1_2,M_Air); OneThree(totaux2_2,M_CH4); OneThree(totaux3_2,M_H2O); OneThree(totaux4_2,M_CH4); OneThree(totaux5_2,M_H2O); OneThree(totaux6_2,M_CO2); OneThree(totaux7_2,M_N2); OneThree(totaux8_2,M_NH3);
                ThreeS(totaux1_3); ThreeS(totaux2_3); ThreeS(totaux3_3); ThreeS(totaux4_3); ThreeS(totaux5_3); ThreeS(totaux6_3); ThreeS(totaux7_3); ThreeS(totaux8_3); 
                OneThree(asu1_2,M_Air); OneThree(asu2_2,M_O2); OneThree(asu3_2,M_N2); OneThree(asu4_2,M_N2); 
                ThreeS(asu1_3); ThreeS(asu2_3); ThreeS(asu3_3); ThreeS(asu4_3); 
                OneThree(comb1_2,M_CH4); OneThree(comb2_2,M_O2); OneThree(comb3_2,M_H2O); OneThree(comb4_2,M_CH4); OneThree(comb5_2,M_O2); OneThree(comb6_2,M_CO2); OneThree(comb7_2,M_H2O);
                ThreeS(comb1_3); ThreeS(comb2_3); ThreeS(comb3_3); ThreeS(comb4_3); ThreeS(comb5_3); ThreeS(comb6_3); ThreeS(comb7_3)
                OneThree(reform1_2,M_CH4); OneThree(reform2_2,M_H2O); OneThree(reform3_2,M_CO2); OneThree(reform6_2,M_CH4); OneThree(reform7_2,M_H2O); OneThree(reform8_2,M_CO2); OneThree(reform9_2,M_CO); OneThree(reform10_2,M_H2);
                ThreeS(reform1_3); ThreeS(reform2_3); ThreeS(reform3_3); ThreeS(reform6_3); ThreeS(reform7_3); ThreeS(reform8_3); ThreeS(reform9_3); ThreeS(reform10_3); 
                OneThree(wgs1_2,M_CO); OneThree(wgs2_2,M_H2O); OneThree(wgs3_2,M_CO2); OneThree(wgs4_2,M_H2); OneThree(wgs5_2,M_CO); OneThree(wgs6_2,M_H2O); OneThree(wgs7_2,M_CO2); OneThree(wgs8_2,M_H2);
                ThreeS(wgs1_3); ThreeS(wgs2_3); ThreeS(wgs3_3); ThreeS(wgs4_3); ThreeS(wgs5_3); ThreeS(wgs6_3); ThreeS(wgs7_3); ThreeS(wgs8_3); 
                OneThree(conabs1_2,M_H2O); OneThree(conabs2_2,M_CO2); 
                ThreeS(conabs1_3); ThreeS(conabs2_3);
                OneThree(synth1_2,M_H2); OneThree(synth2_2,M_N2); OneThree(synth3_2,M_H2); OneThree(synth4_2,M_N2); OneThree(synth5_2,M_NH3); OneThree(synth6_2,M_CH4);
                ThreeS(synth1_3); ThreeS(synth2_3); ThreeS(synth3_3); ThreeS(synth4_3); ThreeS(synth5_3); ThreeS(synth6_3);
                CH4 = CH4*M_CH4/1000/1000*SecPerDay; O2 = O2*M_CO2/1000/1000*SecPerDay; N2 = N2*M_N2/1000/1000*SecPerDay; H2O = H2O*M_H2O/1000/1000*SecPerDay; CO2 = CO2*M_CO2/1000/1000*SecPerDay; CO = CO*M_CO/1000/1000*SecPerDay; H2 = H2*M_H2/1000/1000*SecPerDay; NH3 = NH3*M_NH3/1000/1000*SecPerDay;
                currentUnits = 3;
            elseif currentUnits == 2 && get(source,'Value') == 1 % [kg/s] ---> [mol/s]
                TwoOne(totaux1_2,M_Air); TwoOne(totaux2_2,M_CH4); TwoOne(totaux3_2,M_H2O); TwoOne(totaux4_2,M_CH4); TwoOne(totaux5_2,M_H2O); TwoOne(totaux6_2,M_CO2); TwoOne(totaux7_2,M_N2); TwoOne(totaux8_2,M_NH3);
                OneS(totaux1_3); OneS(totaux2_3); OneS(totaux3_3); OneS(totaux4_3); OneS(totaux5_3); OneS(totaux6_3); OneS(totaux7_3); OneS(totaux8_3); 
                TwoOne(asu1_2,M_Air); TwoOne(asu2_2,M_O2); TwoOne(asu3_2,M_N2); TwoOne(asu4_2,M_N2); 
                OneS(asu1_3); OneS(asu2_3); OneS(asu3_3); OneS(asu4_3); 
                TwoOne(comb1_2,M_CH4); TwoOne(comb2_2,M_O2); TwoOne(comb3_2,M_H2O); TwoOne(comb4_2,M_CH4); TwoOne(comb5_2,M_O2); TwoOne(comb6_2,M_CO2); TwoOne(comb7_2,M_H2O);
                OneS(comb1_3); OneS(comb2_3); OneS(comb3_3); OneS(comb4_3); OneS(comb5_3); OneS(comb6_3); OneS(comb7_3)
                TwoOne(reform1_2,M_CH4); TwoOne(reform2_2,M_H2O); TwoOne(reform3_2,M_CO2); TwoOne(reform6_2,M_CH4); TwoOne(reform7_2,M_H2O); TwoOne(reform8_2,M_CO2); TwoOne(reform9_2,M_CO); TwoOne(reform10_2,M_H2);
                OneS(reform1_3); OneS(reform2_3); OneS(reform3_3); OneS(reform6_3); OneS(reform7_3); OneS(reform8_3); OneS(reform9_3); OneS(reform10_3); 
                TwoOne(wgs1_2,M_CO); TwoOne(wgs2_2,M_H2O); TwoOne(wgs3_2,M_CO2); TwoOne(wgs4_2,M_H2); TwoOne(wgs5_2,M_CO); TwoOne(wgs6_2,M_H2O); TwoOne(wgs7_2,M_CO2); TwoOne(wgs8_2,M_H2);
                OneS(wgs1_3); OneS(wgs2_3); OneS(wgs3_3); OneS(wgs4_3); OneS(wgs5_3); OneS(wgs6_3); OneS(wgs7_3); OneS(wgs8_3); 
                TwoOne(conabs1_2,M_H2O); TwoOne(conabs2_2,M_CO2); 
                OneS(conabs1_3); OneS(conabs2_3);
                TwoOne(synth1_2,M_H2); TwoOne(synth2_2,M_N2); TwoOne(synth3_2,M_H2); TwoOne(synth4_2,M_N2); TwoOne(synth5_2,M_NH3); TwoOne(synth6_2,M_CH4);
                OneS(synth1_3); OneS(synth2_3); OneS(synth3_3); OneS(synth4_3); OneS(synth5_3); OneS(synth6_3);
                CH4 = CH4/M_CH4*1000; O2 = O2/M_CO2*1000; N2 = N2/M_N2*1000; H2O = H2O/M_H2O*1000; CO2 = CO2/M_CO2*1000; CO = CO/M_CO*1000; H2 = H2/M_H2*1000; NH3 = NH3/M_NH3*1000;
                currentUnits = 1;
            elseif currentUnits == 2 && get(source,'Value') == 3 % [kg/s] ---> [t/j]
                TwoThree(totaux1_2,M_Air); TwoThree(totaux2_2,M_CH4); TwoThree(totaux3_2,M_H2O); TwoThree(totaux4_2,M_CH4); TwoThree(totaux5_2,M_H2O); TwoThree(totaux6_2,M_CO2); TwoThree(totaux7_2,M_N2); TwoThree(totaux8_2,M_NH3);
                ThreeS(totaux1_3); ThreeS(totaux2_3); ThreeS(totaux3_3); ThreeS(totaux4_3); ThreeS(totaux5_3); ThreeS(totaux6_3); ThreeS(totaux7_3); ThreeS(totaux8_3); 
                TwoThree(asu1_2,M_Air); TwoThree(asu2_2,M_O2); TwoThree(asu3_2,M_N2); TwoThree(asu4_2,M_N2); 
                ThreeS(asu1_3); ThreeS(asu2_3); ThreeS(asu3_3); ThreeS(asu4_3); 
                TwoThree(comb1_2,M_CH4); TwoThree(comb2_2,M_O2); TwoThree(comb3_2,M_H2O); TwoThree(comb4_2,M_CH4); TwoThree(comb5_2,M_O2); TwoThree(comb6_2,M_CO2); TwoThree(comb7_2,M_H2O);
                ThreeS(comb1_3); ThreeS(comb2_3); ThreeS(comb3_3); ThreeS(comb4_3); ThreeS(comb5_3); ThreeS(comb6_3); ThreeS(comb7_3)
                TwoThree(reform1_2,M_CH4); TwoThree(reform2_2,M_H2O); TwoThree(reform3_2,M_CO2); TwoThree(reform6_2,M_CH4); TwoThree(reform7_2,M_H2O); TwoThree(reform8_2,M_CO2); TwoThree(reform9_2,M_CO); TwoThree(reform10_2,M_H2);
                ThreeS(reform1_3); ThreeS(reform2_3); ThreeS(reform3_3); ThreeS(reform6_3); ThreeS(reform7_3); ThreeS(reform8_3); ThreeS(reform9_3); ThreeS(reform10_3); 
                TwoThree(wgs1_2,M_CO); TwoThree(wgs2_2,M_H2O); TwoThree(wgs3_2,M_CO2); TwoThree(wgs4_2,M_H2); TwoThree(wgs5_2,M_CO); TwoThree(wgs6_2,M_H2O); TwoThree(wgs7_2,M_CO2); TwoThree(wgs8_2,M_H2);
                ThreeS(wgs1_3); ThreeS(wgs2_3); ThreeS(wgs3_3); ThreeS(wgs4_3); ThreeS(wgs5_3); ThreeS(wgs6_3); ThreeS(wgs7_3); ThreeS(wgs8_3); 
                TwoThree(conabs1_2,M_H2O); TwoThree(conabs2_2,M_CO2); 
                ThreeS(conabs1_3); ThreeS(conabs2_3);
                TwoThree(synth1_2,M_H2); TwoThree(synth2_2,M_N2); TwoThree(synth3_2,M_H2); TwoThree(synth4_2,M_N2); TwoThree(synth5_2,M_NH3); TwoThree(synth6_2,M_CH4);
                ThreeS(synth1_3); ThreeS(synth2_3); ThreeS(synth3_3); ThreeS(synth4_3); ThreeS(synth5_3); ThreeS(synth6_3);
                CH4 = CH4*M_CH4/1000*SecPerDay; O2 = O2*M_CO2/1000*SecPerDay; N2 = N2*M_N2/1000*SecPerDay; H2O = H2O*M_H2O/1000*SecPerDay; CO2 = CO2*M_CO2/1000*SecPerDay; CO = CO*M_CO/1000*SecPerDay; H2 = H2*M_H2/1000*SecPerDay; NH3 = NH3*M_NH3/1000*SecPerDay;
                currentUnits = 3;
            elseif currentUnits == 3 && get(source,'Value') == 1 % [t/j] ---> [mol/s]
                ThreeOne(totaux1_2,M_Air); ThreeOne(totaux2_2,M_CH4); ThreeOne(totaux3_2,M_H2O); ThreeOne(totaux4_2,M_CH4); ThreeOne(totaux5_2,M_H2O); ThreeOne(totaux6_2,M_CO2); ThreeOne(totaux7_2,M_N2); ThreeOne(totaux8_2,M_NH3);
                OneS(totaux1_3); OneS(totaux2_3); OneS(totaux3_3); OneS(totaux4_3); OneS(totaux5_3); OneS(totaux6_3); OneS(totaux7_3); OneS(totaux8_3); 
                ThreeOne(asu1_2,M_Air); ThreeOne(asu2_2,M_O2); ThreeOne(asu3_2,M_N2); ThreeOne(asu4_2,M_N2); 
                OneS(asu1_3); OneS(asu2_3); OneS(asu3_3); OneS(asu4_3); 
                ThreeOne(comb1_2,M_CH4); ThreeOne(comb2_2,M_O2); ThreeOne(comb3_2,M_H2O); ThreeOne(comb4_2,M_CH4); ThreeOne(comb5_2,M_O2); ThreeOne(comb6_2,M_CO2); ThreeOne(comb7_2,M_H2O);
                OneS(comb1_3); OneS(comb2_3); OneS(comb3_3); OneS(comb4_3); OneS(comb5_3); OneS(comb6_3); OneS(comb7_3)
                ThreeOne(reform1_2,M_CH4); ThreeOne(reform2_2,M_H2O); ThreeOne(reform3_2,M_CO2); ThreeOne(reform6_2,M_CH4); ThreeOne(reform7_2,M_H2O); ThreeOne(reform8_2,M_CO2); ThreeOne(reform9_2,M_CO); ThreeOne(reform10_2,M_H2);
                OneS(reform1_3); OneS(reform2_3); OneS(reform3_3); OneS(reform6_3); OneS(reform7_3); OneS(reform8_3); OneS(reform9_3); OneS(reform10_3); 
                ThreeOne(wgs1_2,M_CO); ThreeOne(wgs2_2,M_H2O); ThreeOne(wgs3_2,M_CO2); ThreeOne(wgs4_2,M_H2); ThreeOne(wgs5_2,M_CO); ThreeOne(wgs6_2,M_H2O); ThreeOne(wgs7_2,M_CO2); ThreeOne(wgs8_2,M_H2);
                OneS(wgs1_3); OneS(wgs2_3); OneS(wgs3_3); OneS(wgs4_3); OneS(wgs5_3); OneS(wgs6_3); OneS(wgs7_3); OneS(wgs8_3); 
                ThreeOne(conabs1_2,M_H2O); ThreeOne(conabs2_2,M_CO2); 
                OneS(conabs1_3); OneS(conabs2_3);
                ThreeOne(synth1_2,M_H2); ThreeOne(synth2_2,M_N2); ThreeOne(synth3_2,M_H2); ThreeOne(synth4_2,M_N2); ThreeOne(synth5_2,M_NH3); ThreeOne(synth6_2,M_CH4);
                OneS(synth1_3); OneS(synth2_3); OneS(synth3_3); OneS(synth4_3); OneS(synth5_3); OneS(synth6_3);
                CH4 = CH4/M_CH4*1000*1000/SecPerDay; O2 = O2/M_CO2*1000*1000/SecPerDay; N2 = N2/M_N2*1000*1000/SecPerDay; H2O = H2O/M_H2O*1000*1000/SecPerDay; CO2 = CO2/M_CO2*1000*1000/SecPerDay; CO = CO/M_CO*1000*1000/SecPerDay; H2 = H2/M_H2*1000*1000/SecPerDay; NH3 = NH3/M_NH3*1000*1000/SecPerDay;
                currentUnits = 1;
            elseif currentUnits == 3 && get(source,'Value') == 2 % [t/j] ---> [kg/s]
                ThreeTwo(totaux1_2,M_Air); ThreeTwo(totaux2_2,M_CH4); ThreeTwo(totaux3_2,M_H2O); ThreeTwo(totaux4_2,M_CH4); ThreeTwo(totaux5_2,M_H2O); ThreeTwo(totaux6_2,M_CO2); ThreeTwo(totaux7_2,M_N2); ThreeTwo(totaux8_2,M_NH3);
                TwoS(totaux1_3); TwoS(totaux2_3); TwoS(totaux3_3); TwoS(totaux4_3); TwoS(totaux5_3); TwoS(totaux6_3); TwoS(totaux7_3); TwoS(totaux8_3); 
                ThreeTwo(asu1_2,M_Air); ThreeTwo(asu2_2,M_O2); ThreeTwo(asu3_2,M_N2); ThreeTwo(asu4_2,M_N2); 
                TwoS(asu1_3); TwoS(asu2_3); TwoS(asu3_3); TwoS(asu4_3); 
                ThreeTwo(comb1_2,M_CH4); ThreeTwo(comb2_2,M_O2); ThreeTwo(comb3_2,M_H2O); ThreeTwo(comb4_2,M_CH4); ThreeTwo(comb5_2,M_O2); ThreeTwo(comb6_2,M_CO2); ThreeTwo(comb7_2,M_H2O);
                TwoS(comb1_3); TwoS(comb2_3); TwoS(comb3_3); TwoS(comb4_3); TwoS(comb5_3); TwoS(comb6_3); TwoS(comb7_3)
                ThreeTwo(reform1_2,M_CH4); ThreeTwo(reform2_2,M_H2O); ThreeTwo(reform3_2,M_CO2); ThreeTwo(reform6_2,M_CH4); ThreeTwo(reform7_2,M_H2O); ThreeTwo(reform8_2,M_CO2); ThreeTwo(reform9_2,M_CO); ThreeTwo(reform10_2,M_H2);
                TwoS(reform1_3); TwoS(reform2_3); TwoS(reform3_3); TwoS(reform6_3); TwoS(reform7_3); TwoS(reform8_3); TwoS(reform9_3); TwoS(reform10_3); 
                ThreeTwo(wgs1_2,M_CO); ThreeTwo(wgs2_2,M_H2O); ThreeTwo(wgs3_2,M_CO2); ThreeTwo(wgs4_2,M_H2); ThreeTwo(wgs5_2,M_CO); ThreeTwo(wgs6_2,M_H2O); ThreeTwo(wgs7_2,M_CO2); ThreeTwo(wgs8_2,M_H2);
                TwoS(wgs1_3); TwoS(wgs2_3); TwoS(wgs3_3); TwoS(wgs4_3); TwoS(wgs5_3); TwoS(wgs6_3); TwoS(wgs7_3); TwoS(wgs8_3); 
                ThreeTwo(conabs1_2,M_H2O); ThreeTwo(conabs2_2,M_CO2); 
                TwoS(conabs1_3); TwoS(conabs2_3);
                ThreeTwo(synth1_2,M_H2); ThreeTwo(synth2_2,M_N2); ThreeTwo(synth3_2,M_H2); ThreeTwo(synth4_2,M_N2); ThreeTwo(synth5_2,M_NH3); ThreeTwo(synth6_2,M_CH4);
                TwoS(synth1_3); TwoS(synth2_3); TwoS(synth3_3); TwoS(synth4_3); TwoS(synth5_3); TwoS(synth6_3);
                CH4 = CH4*1000/SecPerDay; O2 = O2*1000/SecPerDay; N2 = N2*1000/SecPerDay; H2O = H2O*1000/SecPerDay; CO2 = CO2*1000/SecPerDay; CO = CO*1000/SecPerDay; H2 = H2*1000/SecPerDay; NH3 = NH3*1000/SecPerDay;
                currentUnits = 2;
            end
        catch ME
            OneS(totaux1_3); OneS(totaux2_3); OneS(totaux3_3); OneS(totaux4_3); OneS(totaux5_3); OneS(totaux6_3); OneS(totaux7_3); OneS(totaux8_3); 
            OneS(asu1_3); OneS(asu2_3); OneS(asu3_3); OneS(asu4_3); 
            OneS(comb1_3); OneS(comb2_3); OneS(comb3_3); OneS(comb4_3); OneS(comb5_3); OneS(comb6_3); OneS(comb7_3)
            OneS(reform1_3); OneS(reform2_3); OneS(reform3_3); OneS(reform6_3); OneS(reform7_3); OneS(reform8_3); OneS(reform9_3); OneS(reform10_3); 
            OneS(wgs1_3); OneS(wgs2_3); OneS(wgs3_3); OneS(wgs4_3); OneS(wgs5_3); OneS(wgs6_3); OneS(wgs7_3); OneS(wgs8_3); 
            OneS(conabs1_3); OneS(conabs2_3);
            OneS(synth1_3); OneS(synth2_3); OneS(synth3_3); OneS(synth4_3); OneS(synth5_3); OneS(synth6_3);
            currentUnits = 1;
            set(units_select,'Value',1);
        end   
    end

    function plotReactif(source,callbackdata)
    %% PLOTREACTIF Crée un graphe des réactifs sélectionnés dans
     %            l'interface graphique.
        plotfig = figure(); hold on;
        ax = gca;
        ax.XTickLabel = {'ASU' 'COMB','REFORM','WGS','CON/ABS','SYNTH'};
        xlabel('Étapes');
        if currentUnits == 1
            ylabel('Débits molaires [mol/s]');
        elseif currentUnits == 2
            ylabel('Débits massiques [kg/s]');
        else
            ylabel('Débits massiques [t/j]');
        end
        
        title('Débits après chaque étape du procédé')
        i = 1;
        if get(plot1,'Value')==1
            plot(CH4);
            legendInfo{i} = ['CH4']; 
            i = i + 1;
        end
        if get(plot2,'Value')==1
            plot(O2);
            legendInfo{i} = ['O2']; 
            i = i + 1;
        end
        if get(plot3,'Value')==1
            plot(N2);
            legendInfo{i} = ['N2']; 
            i = i + 1;
        end
        if get(plot4,'Value')==1
            plot(H2O);
            legendInfo{i} = ['H2O']; 
            i = i + 1;
        end
        if get(plot5,'Value')==1
            plot(CO2);
            legendInfo{i} = ['CO2']; 
            i = i + 1;
        end
        if get(plot6,'Value')==1
            plot(CO);
            legendInfo{i} = ['CO']; 
            i = i + 1;
        end
        if get(plot7,'Value')==1
            plot(H2);
            legendInfo{i} = ['H2']; 
            i = i + 1;
        end
        if get(plot8,'Value')==1
            plot(NH3);
            legendInfo{i} = ['NH3']; 
            i = i + 1;
        end
        legend(legendInfo);
    end

    % Afin de ne pas créer une nouvelle interface graphique à chaque
    % simulation, le programme vérifie d'abord si l'interface existe déjà
    % avant d'en créer une nouvelle.
    try
        titl.Visible;
    catch ME
        createGui();
    end
    
    % Exécute toutes les étapes du procédé.
    preprocess();
    combustion();
    reformage();
    watergasshift();
    synthese();
end

