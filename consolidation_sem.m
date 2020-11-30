function consolidation_semantique = consolidation_sem(phase)
%Cette fonction est conçue pour mesurer la consolidation sémantique après
%une nuit de sommeil.
%La première condition (1)  est la phase de mémorisation. Elle consiste à présenter
%une image d'objet pairée avec un non-mot à chaque 5 secondes (nombre de paires = 20
%(100s;1min40s). À la fin de la présentation, l'écran se ferme.
%La deuxième condition (2) est la phase test de l'expérimentation pour
%mesurer la consolidation sémantique. Un non-mot présenté lors de la séance
%de mémorisation est présenté un centre-bas de l'écran et 3 secondes plus
%tard, deux catégories sémantique (e.g. animaux apparaissent en haut à gauche et en haut
%à droite. Le participant doit appuyer sur "z" pour sélectionner la catégorie
%de gauche et "m" pour sélectionner la catégorie de droite.


%Nettoyer le workspace et l'écran des précédentes opérations
clc;
close all;

%Renvoie un message d'erreur si la version de PsychToolBox n'est pas basée
%sur OpenGL ou si Screen() ne fonctionne pas bien
AssertOpenGL;

%Amorce le générateur de nombres aléatoires afin que tous les nombres générés soient vraiment "aléatoires"
rng('shuffle');

screens=Screen('Screens');
screenNumber=max(screens);

%Initialiser la fonction de structure pour éventuellement entrer les
%informations du participant et ses TR
info_par = struct;

home_dir=cd;
%addpath(fullfile(/projet_de_session/Images));

%Demander numéro de participant et âge dans la Command Window
num_par = input('Numéro de participant: ');
info_par.NumParticipant = num_par;
age_par = input('Âge: ');
info_par.AgeParticipant = age_par;

%Initialiser des variables pour enregistrer par la suite si le participant
%a complété les tâches 1 et/ou 2
phase_1 = 0;
phase_2 = 0;

%Matrices contenant les noms des catégories sémantiques qui ont été
%présentées (m_cat_fam) et les catégories sémantiques qui n'ont pas été
%présentées (m_cat_unfam)
m_cat_fam = ["Bureau" "Animal" "Sport" "Plante" "Breuvage" "Fruit" "Insecte" "Légume" "Meuble"];
m_cat_unfam = ["Instrument de musique" "Véhicule" "Poisson" "Art" "Arme" "Outil" "Bâtiment" "Vêtement"];

vecteur_non_mots = ["tâfethor" "sarybêt" "lenêcheg" "gecolêt" "gugareg" "labèlel" "ramomet" "gasafod" "yarevat" "lêmobur" "ceduphèc" "cosonem" "botamom" "fanisîr" "cynofép" "poçamec" "kasifoc" "cémacèm"];
image_mat = ["abeille.jpeg","bleuet.jpeg","brocheuse.jpg","brocoli.jpg","café.jpeg","canapé.jpg","carotte.jpeg","fourmi.jpeg","Girafe.jpg","kiwi.png","lion.jpeg","mojito.jpeg","stylo.jpg","succulente.jpeg","tennis.jpeg","vélo.jpeg","arbre.jpg",'table.jpg'];
stim_path=fullfile(home_dir,sprintf('/Images/'));
temp_dir=dir(fullfile(stim_path,'*.jpg'));

nstim=length(temp_dir); %18
n_non_mots=length(vecteur_non_mots); %18
ntrials=nstim; %18
ordre_img_essais=randperm(ntrials,ntrials);

%Si la condition est '1', voici ce que la fonction exécutera:
% -> Présenter une paire non-mot + image, une à la fois à l’écran
% -> Après 5 secondes, la paire non-mot + image change pour la prochaine
if phase == 1
    %La valeur de phase_1 devient 1 à la place de 0 pour enregistrer le
    %fait que le participant a complété la phase 1
    phase_1 = 1;
    
    Screen('Preference','SkipSyncTests',1);
    
    white = WhiteIndex(screenNumber);
    grey = [255 255 255]/2;
    
    [window,windowRect] = Screen('OpenWindow',screenNumber,grey);
    
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %Remove Cursor from screen during experiment
    HideCursor;
    
    %Taille de l'écran en pixels
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    %Centre de l'écran
    [xCenter, yCenter] = RectCenter(windowRect);
    
    for trial = 1:ntrials
        
        img_number=ordre_img_essais(trial);
        stim_fname=fullfile(temp_dir(img_number).folder,temp_dir(img_number).name);
        %stim_fname_sorted = sort(stim_fname);
        info_par.img_number(trial)=img_number;
        %info_par.stim_fname(trial)=stim_fname;
        
        %Image et mot qu'on présente
        image_presented = imread(stim_fname);
        word_presented = vecteur_non_mots(ordre_img_essais(trial));
        
        %Redimensionner l'image à un ratio qui correspond au 1/3
        %de la largeur et de la hauteur de l'écran pour chacune des images.
        %Ainsi, toutes les images présentées ont la même taille par rapport
        %à l'écran.
        [oldHeight,oldWidth,oldNumberOfColorChannels] = size(image_presented);
        newWidth = screenXpixels/3;
        newHeight = screenYpixels/3;
        image_presented_croped = imresize(image_presented, [newHeight newWidth]);
        
        image_texture = Screen('MakeTexture',window,image_presented_croped);
        
        Screen('DrawTexture',window,image_texture,[],[]);
        
        %Partie texte de l'image: À chaque itération, on sélectionne le mot
        %à la position 'compteur' du vecteur 'vecteur_non_mot'.
        Screen('TextSize', window, 90);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window,num2str(word_presented),'center',screenYpixels * 0.75,white,windowRect);
        
        %The flip command takes everything that has been drawn and actually pushes it to the display.
        %Without the flip command the images you draw will remain offscreen!
        Screen('Flip',window);
        
        %Attendre 5 secondes avant de passer à l'image suivante
        WaitSecs(2);
        trial+1;
    end
    %It is very important to always end a script with this command if drawing is involved to send control of the screen back to MATLAB.
    Screen('CloseAll');
    
elseif phase == 2
    phase_2 = 1;
    
    %Cette partie du code représente une partie importante de la phase 2. Nous
    %générons d'abord une matrice de 12 non-mots sélectionné aléatoirement
    %parmi les 18 non-mots qui ont été présenté durant la phase de
    %mémorisation. Par la suite, nous avons une boucle qui parcours chaque
    %cases de la matrice «m_catEtNonMot» pour récupérer la catégorie des
    %non-mots qui seront testés (i.e. ceux de la matrice «mots_phase2»).
    
    vecteur_non_mots = ["tâfethor" "sarybêt" "lenêcheg" "gecolêt" "gugareg" "labèlel" "ramomet" "gasafod" "yarevat" "lêmobur" "ceduphèc" "cosonem" "botamom" "fanisîr" "cynofép" "poçamec" "kasifoc" "cémacèm"];
    
    %Matrice des non-mots présentés dans la phase 1 sous leur catégorie
    %sémantique correspondante
    
    m_catEtNonMot = ["Bureau" "Animal" "Sport" "Plante" "Breuvage" "Fruit" "Insecte" "Légume" "Meuble";...
        "lenêcheg" "yarevat" "cynofép" "fanisîr" "gugareg" "sarybêt" "tâfethor" "gecolêt" "labèlel";...
        "botamom" "ceduphèc" "poçamec" "kasifoc" "cosonem" "lêmobur" "gasafod" "ramomet" "cémacèm"];
    
    m_cat_unfam = ["Musique" "Véhicule" "Poisson" "Art" "Arme" "Outil" "Bâtiment" "Vêtement" "Bonbon"];
    
    %Martice de 12 nombres aléatoires entre 1 et 18
    m_12rand = randperm(18,12);
    %Matrice qui contiendra les non-mots aux positions correspondantes de
    %la matrice m_12rand
    mots_phase2 = ["","","","","","","","","","","",""];
    
    %Boucle qui parcours les cases de la matrice m_12rand en insérant le
    %mot correspondant à cette position dans la matrice mots_phase2. De
    %cette façon, les mots qui seront testés seront aléatoirement définit
    %entre les participants
    for compteur = 1:length(m_12rand)
        
        index = m_12rand(compteur);
        mots_phase2(compteur) = vecteur_non_mots(index);
        
        compteur = compteur+1;
    end
    
    %Matrice contenant la position du mot qu'on cherche ([rangée colonne])
    position_mot_ran_col = [];
    %Selon le mot qu'on cherche, la catégorie correspondante à ce mot sera
    %enregistrée dans cette matrice
    categorie_mot_phase2 = ["","","","","","","","","","","",""];
    
    for index = 1:length(mots_phase2)
        for rangee = 2:3
            for colonne = 1:9
                if mots_phase2(index) == m_catEtNonMot(rangee,colonne)
                    position_mot_ran_col = [rangee colonne];
                    categorie_mot_phase2(1,index) = m_catEtNonMot(1,colonne);
                else
                    continue
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %La partie suivante représente les procédures pour afficher le non-mots
    %présenté en bas au centre de l'écran et en haut, d'un côté une
    %catégorie présentée (la bonne ou non, selon la condition) et de
    %l'autre, une catégorie jamais présentée.
    
    % Définir les couleurs d'avance
    white = WhiteIndex(screenNumber);
    grey = [255 255 255]/2;
    
    %Paramètres d'initialisation d'écran
    screens=Screen('Screens');
    screenNumber=max(screens);
    [window,windowRect] = Screen('OpenWindow',screenNumber,grey);
    Screen('Preference','SkipSyncTests',1);
    
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %Taille de l'écran en pixels
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    %Centre de l'écran
    [xCenter, yCenter] = RectCenter(windowRect);
    
    %Initialiser des variables qui contiendront les touches correspondantes
    %à «z» et «m» pour le KbWait plus loin
    z_Kb = KbName('z');
    m_Kb = KbName('m');
    
    % Restrict keys to 'z' (29) and 'm' (16)
    RestrictKeysForKbCheck([z_Kb m_Kb]);
    % Remove Cursor from screen during experiment
    HideCursor;
    
    %Initialiser les matrices qui contiendront les informations à extraire
    %pour le participant (TR, réponse à chaque essai et la condition selon
    %l'essai)
    tempsRep = [];
    repEssai = [];
    conditionCat = [];
    
    for compteur = 1:length(mots_phase2)
        
        %Non-mot qui sera testé à l'essai «compteur»
        motTest = mots_phase2(1,compteur);
        
        %Bonne catégorie sémantique correspondant au non-mot présenté
        bonneCat = categorie_mot_phase2(1,compteur);
        
        %Catégorie qui a été présenté, mais qui ne correspond pas à la
        %catégorie sémantique qui correspond au non-mot présenté
        mauvaiseCat = m_catEtNonMot(1,randi([1 9]));
        %Si la catégorie est la même que la bonne catégorie, changer de
        %catégorie
        if mauvaiseCat == bonneCat
            mauvaiseCat = m_catEtNonMot(1,randi([1 9]));
        end
        
        %Catégorie jamais présenté qui sera présentée à cet essai
        catJamaisPres = m_cat_unfam(1,randi([1 9]));
        
        %Morceau pour format le font et le size, puis pour enregistrer le mot à
        %présenter (position, couleur également)
        Screen('TextSize', window, 90);
        Screen('TextFont', window, 'Times');
        %Non-mot présenté initialement qui est représenté à nouveau en bas au
        %centre en blanc
        
        %Définir aléatoire si la condition sera 0 (on présente la bonne
        %catégorie d'un côté et une catégorie jamais présentée de l'autre)
        %ou 1 (on présente la mauvaise catégorie d'un côté et une catégorie
        %jamais présentée de l'autre)
        condition = randi([0 1]);
        conditionCat(1,compteur) = condition;
        %Condition 0 --> bonne catégorie et catégorie jamais présentée
        if condition == 0
            DrawFormattedText(window,num2str(motTest),'center',screenYpixels * 0.75,white,windowRect);
            
            DrawFormattedText(window,num2str(bonneCat),screenXpixels * 0.18,screenYpixels * 0.25,white,windowRect);
            
            DrawFormattedText(window,num2str(catJamaisPres),screenXpixels * 0.68,screenYpixels * 0.25,white,windowRect);
            
            %Condition 1 --> mauvaise catégorie et catégorie jamais présentée
        elseif condition == 1
            DrawFormattedText(window,num2str(motTest),'center',screenYpixels * 0.75,white,windowRect);
            
            DrawFormattedText(window,num2str(mauvaiseCat),screenXpixels * 0.18,screenYpixels * 0.25,white,windowRect);
            
            DrawFormattedText(window,num2str(catJamaisPres),screenXpixels * 0.68,screenYpixels * 0.25,white,windowRect);
            
        end
        
        % set time 0 (for reaction time)
        secs0 = GetSecs;
        
        Screen('Flip',window);
        
        %Durée de la présentation des mots avant que le participant puisse
        %appuyer sur une touche
        WaitSecs(.5);
        
        KbWait;
        
        % Collect keyboard response
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;% Wait for and checkwhich key was pressed
        response=KbName(keyCode);
        
        RT=(secs-secs0) - 0.5;% Get reaction time
        
        %Enregistrer les réponses à chaque essai dans la matrice «repEssai»
        repEssai(1,compteur) = response;
        
        %Enregistrer les TR à chaque essai dans la matrice «tempsRep»
        tempsRep(1,compteur) = RT;
        
    end
    
    Screen('CloseAll');
    
else
    disp("La condition entrée n'est pas valide. Veuillez entrer 1 ou 2, dépendamment de la condition");
    
end

%Les deux boucles suivantes vont changer les valeurs des variables de
%complétion de tâche afin d'enregistrer si les tâches ont été complétées
if phase_1 == 1
    info_par.Phase1Completed = 'Completed';
elseif phase_1 == 0
    info_par.Phase1Completed = 'Not Completed';
end

if phase_2 == 1
    info_par.Phase2Completed = 'Completed';
elseif phase_2 == 0
    info_par.Phase2Completed = 'Not Completed';
end

info_par
