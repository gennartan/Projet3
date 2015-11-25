function main(m_CH4, R_O2_CH4, R_H2O_CH4, T_ATR, p_ATR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    global fig title results params params1_1 params1_2 params1_3 params2_1 params2_2 params2_3 params3_1 params3_2 params3_3 params4_1 params4_2 params4_3 params5_1 params5_2 params5_3;
    global totaux totaux1_1 totaux1_2 totaux1_3 totaux2_1 totaux2_2 totaux2_3 totaux3_1 totaux3_2 totaux3_3 totaux4_1 totaux4_2 totaux4_3 totaux5_1 totaux5_2 totaux5_3 totaux6_1 totaux6_2 totaux6_3 totaux7_1 totaux7_2 totaux7_3 totaux8_1 totaux8_2 totaux8_3 totaux9_1 totaux9_2 totaux9_3 totaux10_1 totaux10_2 totaux10_3;
    global asu asu1_1 asu1_2 asu1_3 asu2_1 asu2_2 asu2_3 asu3_1 asu3_2 asu3_3 asu4_1 asu4_2 asu4_3;
    global comb comb1_1 comb1_2 comb1_3 comb2_1 comb2_2 comb2_3 comb3_1 comb3_2 comb3_3 comb4_1 comb4_2 comb4_3 comb5_1 comb5_2 comb5_3 comb6_1 comb6_2 comb6_3 comb7_1 comb7_2 comb7_3 comb8_1 comb8_2 comb8_3 comb9_1 comb9_2 comb9_3;
    global reform reform1_1 reform1_2 reform1_3 reform2_1 reform2_2 reform2_3 reform3_1 reform3_2 reform3_3 reform4_1 reform4_2 reform4_3 reform5_1 reform5_2 reform5_3 reform6_1 reform6_2 reform6_3 reform7_1 reform7_2 reform7_3 reform8_1 reform8_2 reform8_3 reform9_1 reform9_2 reform9_3 reform10_1 reform10_2 reform10_3 reform11_1 reform11_2 reform11_3 reform12_1 reform12_2 reform12_3;
    global wgs wgs1_1 wgs1_2 wgs1_3 wgs2_1 wgs2_2 wgs2_3 wgs3_1 wgs3_2 wgs3_3 wgs4_1 wgs4_2 wgs4_3 wgs5_1 wgs5_2 wgs5_3 wgs6_1 wgs6_2 wgs6_3 wgs7_1 wgs7_2 wgs7_3 wgs8_1 wgs8_2 wgs8_3;
    global conabs conabs1_1 conabs1_2 conabs1_3 conabs2_1 conabs2_2 conabs2_3;
    global synth synth1_1 synth1_2 synth1_3 synth2_1 synth2_2 synth2_3 synth3_1 synth3_2 synth3_3 synth4_1 synth4_2 synth4_3 synth5_1 synth5_2 synth5_3 synth6_1 synth6_2 synth6_3;
    global btn_simul panel_select units_select;
    global R_O2_Air R_N2_Air SecPerDay;
    global M_Air M_CH4 M_CO M_CO2 M_H2 M_H2O M_N2 M_NH3 M_O2;
    global n_CH4 n_O2 n_H2O n_Air n_N2 n_CO2 n_CO n_H2;
        
    R_O2_Air = 0.21; R_N2_Air = 0.79; SecPerDay = 86400;
    M_O2  = 32.0; M_N2  = 28.0; M_H2O = 18.0; M_CH4 = 16.0; M_CO2 = 44.0; M_CO  = 28.0; M_H2  = 2.0 ; M_NH3 = 17.0; M_Air = 28.97;
    
    function createGui()
        fig = figure('Visible','off','Position',[100,100,800,500],'Name','Gestion de la production d''ammoniac Groupe 1264','ToolBar','none','MenuBar','none','NumberTitle','off');
        title  = uicontrol('Style','text','Fontsize',20,'String','Gestion de la production d''ammoniac','Position',[0,470,800,30]);
        params = uipanel('Parent',fig,'Title','Paramètres','FontSize',12,'FontWeight','bold','Visible','on','Units','pixels','Position',[5, 340,350,130]);
            params1_1  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','Débit d''alimentation de CH4','HorizontalAlignment','left','Position',[5,90,250,15]);
            params1_2 = uicontrol('Parent',params,'Style','edit','BackgroundColor',[1 1 1],'String','FILL','HorizontalAlignment','center','Position',[255,90,50,15]);
            params1_3  = uicontrol('Parent',params,'Style','text','BackgroundColor',[1 1 1],'String','T/j','HorizontalAlignment','right','Position',[305,90,40,15]);
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
        panel_select = uicontrol('Style','popupmenu','String', {'Totaux','Air Separation Unit','ATR : combustion','ATR : reformage','Water Gas Shift','Condensation/Absorption','Synthèse de l''ammoniac'},'Callback', @setpanel,'Position',[15,250,330,25]);
        units_select = uicontrol('Style','popupmenu','String', {'mol/s','kg/s','T/s'},'Position',[15,225,330,25]);
        set(fig,'Visible','on');
    end    
    function preprocess()
        % Fill params
        set(params1_2,'String',m_CH4);
        set(params2_2,'String',R_O2_CH4);
        set(params3_2,'String',R_H2O_CH4);
        set(params4_2,'String',T_ATR);
        set(params5_2,'String',p_ATR);
        
        % Calculate
        n_CH4 = m_CH4*(10^6)/M_CH4/SecPerDay;
        n_O2  = R_O2_CH4 * n_CH4;
        n_H2O = R_H2O_CH4 * n_CH4;
        n_Air = n_O2 / R_O2_Air;
        n_N2 = n_Air * R_N2_Air;
        
        % Fill
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
        % Calcul
        n_reac = min(n_CH4, n_O2/2); % [mol/s] nombre de mol reagissant (par unité de mole de CO2 produite)
        n_O2 = n_O2 - 2*n_reac; % [mol/s]
        n_CH4 = n_CH4 - n_reac;
        n_H2O = n_H2O + 2*n_reac;
        n_CO2 = n_reac;
        
        % Fill
        set(comb4_2,'String',n_CH4);
        set(comb5_2,'String',n_O2);
        set(comb6_2,'String',n_CO2);
        set(comb7_2,'String',n_H2O);
        set(reform1_2,'String',n_CH4);
        set(reform2_2,'String',n_H2O);
        set(reform3_2,'String',n_CO2);
    end
    function reformage()
        KSMR = 10^((-11650/T_ATR)+13.076);
        KWGS = 10^((1910/T_ATR)-1.764);
        function F = myfun(x)
            % X(1) : degre d'avancement de la premiere reaction [mol/s]
            % X(2) : degre d'avancement de la seconde reaction [mol/s]
            F(1) = (((x(1)-x(2))*(3*x(1)+x(2))^3 * (p_ATR)^2) / ((n_CH4+n_H2O+2*x(1)+n_CO2)^2 * (n_H2O-x(1)-x(2))*(n_CH4-x(1)))) - KSMR;
            F(2) = ( ((n_CO2+x(2))*(3*x(1)+x(2))) / ((x(1)-x(2))*(n_H2O-x(1)-x(2))) ) -KWGS;
        end
    	X0(1) = 0.82*n_CH4;
    	X0(2) = 0.05*n_CH4;
    	OPTIONS = optimoptions('fsolve', 'MaxFunEvals', 1000);
    	X = fsolve(@myfun, X0, OPTIONS)
        X(1) = 335.6;
        X(2) = 11.9;
        
        n_CH4 = (n_CH4-X(1));
        n_H2O = (n_H2O-X(1)-X(2));
        n_H2 = (3*X(1)+X(2));
        n_CO = (X(1)-X(2));
        n_CO2 = (n_CO2+X(2));
        
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
    end
    function watergasshift()
        n_reac=min(n_CO, n_H2O);
        n_H2O = n_H2O-n_reac;
        n_CO = n_CO-n_reac;
        n_H2 = n_H2+n_reac;
        n_CO2 = n_CO2+n_reac;
        
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
        n_reac=min(n_N2, n_H2/3);
        n_H2 = n_H2-3*n_reac;
        n_N2 = n_N2-n_reac; 
        n_NH3 = 2*n_reac;
        
        set(synth3_2,'String',n_H2);
        set(synth4_2,'String',n_N2);
        set(synth5_2,'String',n_NH3);
        set(totaux7_2,'String',n_N2);
        set(totaux8_2,'String',n_NH3);
    end

    function simulate(source,callbackdata)
        main(str2num(get(params1_2,'String')), ...
             str2num(get(params2_2,'String')), ...
             str2num(get(params3_2,'String')), ...
             str2num(get(params4_2,'String')), ...
             str2num(get(params5_2,'String')));
    end

    try
        title.Visible;
    catch ME
        createGui();
    end
    
    preprocess();
    combustion();
    reformage();
    watergasshift();
    synthese();

    %===== Graphical Functions =====
    function setpanel(source,callbackdata)
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


end

