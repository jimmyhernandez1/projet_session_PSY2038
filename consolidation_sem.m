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

%Amorce le générateur de nombres aléatoires afin que tous les nombres générés soient vraiment "aléatoires"
rng('shuffle');

screens=Screen('Screens');
screenNumber=max(screens);

%Initialiser la fonction de structure pour éventuelement entrer les
%informations du participant et ses TR
info_par = struct;

%Demander numéro de participant et âge dans la Command Window
num_par = input('Numéro de participant: ');
info_par.NumParticipant = num_par;
age_par = input('Âge: ');
info_par.AgeParticipant = age_par;

%Initialiser des variables pour enregistrer par la suite si le participant
%a complété les tâches 1 et/ou 2
task_1 = 0;
task_2 = 0;

%Matrices contenant les noms des catégories sémantiques qui ont été
%présentées (m_cat_fam) et les catégories sémantiques qui n'ont pas été
%présentées (m_cat_unfam)
m_cat_fam = ["Bureau" "Animal" "Sport" "Plante" "Breuvage" "Fruit" "Insecte" "Légume" "Meuble"];
m_cat_unfam = ["Instrument de musique" "Véhicule" "Poisson" "Art" "Arme" "Outil" "Bâtiment" "Vêtement"];

%Noms des fichiers d'images contenus dans leur catégorie sémantique
%respective
%m_cat_bureau = ["brocheuse.jpg";"stylo.jpg"];
%m_cat_animal = ["Girafe.jpg";"lion.jpeg"];
%m_cat_sport = ["tennis.jpeg";"vélo.jpeg"];
%m_cat_plante = ["succulente.jpeg";"arbre.jpg"];
%m_cat_breuvage = ["mojito.jpeg";"café.jpeg"];
%m_cat_fruit = ["bleuet.jpeg";"kiwi.png"];
%m_cat_insecte = ["abeille.jpeg";"fourmi.jpeg"];
%m_cat_legume = ["carotte.jpeg";"brocoli.jpg"];
%m_cat_meuble = ["canapé.jpg";"table.jpg"];

%Matrice résultant de la concaténation de toutes les matrices de catégories
%sémantique 
%m_cat_files = horzcat(m_cat_bureau,m_cat_animal,m_cat_sport,m_cat_plante,m_cat_breuvage,m_cat_fruit,m_cat_insecte,m_cat_legume,m_cat_meuble)

%Si la condition est '1', voici ce que la fonction exécutera:
% -> Présenter une paire non-mot + image, une à la fois à l’écran
% -> Après 5 secondes, la paire non-mot + image change pour la prochaine
if phase == 1
    
    %Ouvre une boîte de dialogue qui demande les informations du participant
    %dans l'optique de stocker ses réponses avec ses informations à des fins d'analyse
    task_1 = 1;
    
    
    Screen('Preference','SkipSyncTests',1);
    
    veteur_non_mots = ["tâfethor" "sarybêt" "lenêcheg" "gecolêt" "gugareg" "labèlel" "ramomet" "gasafod" "yarevat" "lêmobur" "ceduphèc" "cosonem" "botamom" "fanisîr" "cynofép" "poçamec" "kasifoc" "cémacèm"];
    image_mat = ["abeille.jpeg","bleuet.jpeg","brocheuse.jpg","brocoli.jpg","café.jpeg","canapé.jpg","carotte.jpeg","fourmi.jpeg","Girafe.jpg","kiwi.png","lion.jpeg","mojito.jpeg","stylo.jpg","succulente.jpeg","tennis.jpeg","vélo.jpeg","arbre.jpg",'table.jpg'];
    
    white = WhiteIndex(screenNumber);
    
    [window,windowRect] = Screen('OpenWindow',screenNumber,[0 0 0]);
    
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %Remove Cursor from screen during experiment
    HideCursor;
    
    %Taille de l'écran en pixels
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    %Centre de l'écran
    [xCenter, yCenter] = RectCenter(windowRect);
    
    for compteur = 1:length(image_mat)
        %Image et mot qu'on présente
        image_presented = imread(image_mat(compteur));
        word_presented = veteur_non_mots(compteur);
        
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
        WaitSecs(1);
        compteur+1;
    end
    %It is very important to always end a script with this command if drawing is involved to send control of the screen back to MATLAB.
        Screen('CloseAll');
        
elseif phase == 2
    
    
    
else
    disp("La condition entrée n'est pas valide. Veuillez entrer 1 ou 2, dépendamment de la condition");
    
end

%Les deux boucles suivantes vont changer les valeurs des variables de
%complétion de tâche afin d'enregistrer si les tâches ont été complétées
if task_1 == 1
    info_par.Task1Completed = 'Completed';
elseif task_1 == 0
    info_par.Task1Completed = 'Not Completed';
end

if task_2 == 1
    info_par.Task2Completed = 'Completed';
elseif task_2 == 0
    info_par.Task2Completed = 'Not Completed';
end

info_par
