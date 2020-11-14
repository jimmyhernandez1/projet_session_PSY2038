function consolidation_semantique = consolidation_sem(condition)
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
%clear all;
close all;

%Amorce le générateur de nombres aléatoires afin que tous les nombres générés soient vraiment "aléatoires"
rng('shuffle');

screens=Screen('Screens');
screenNumber=max(screens);

%Si la condition est '1', voici ce que la fonction exécutera:
% -> Présenter une paire non-mot + image, une à la fois à l’écran
% -> Après 5 secondes, la paire non-mot + image change pour la prochaine
if condition == 1
    
    %Ouvre une boîte de dialogue qui demande les informations du participant
    %dans l'optique de stocker ses réponses avec ses informations à des fins d'analyse
    prompt = ({'Code de participant:','Âge:'});
    dlgtitle = 'Information du participant';
    dims = [1 40; 1 40]
    info_participant = inputdlg(prompt,dlgtitle,dims)
    
    Screen('Preference','SkipSyncTests',1);
    
    veteur_non_mots = ["tâfethor" "nognurel" "sarybêt" "lenêcheg" "gecolêt" "gugareg" "labèlel" "ramomet" "gasafod" "yarevat" "lêmobur" "ceduphèc" "cosonem" "botamom" "fanisîr" "quytamaf" "cynofép" "poçamec" "kasifoc" "cémacèm"];
    image_mat = ["bleuet.jpeg","brocheuse.jpg","brocoli.jpg","café.jpeg","canapé.jpg","carotte.jpeg","ciseaux.jpg","fourmi.jpeg","Girafe.jpg","kiwi.png","lion.jpeg","mojito.jpeg","paresseux.jpeg","pizza.jpg","stylo.jpg","succulente.jpeg","tennis.jpeg","vélo.jpeg"];
    
    white = WhiteIndex(screenNumber);
    
    [window,windowRect] = PsychImaging('OpenWindow',screenNumber,[0 0 0]);
    
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %Remove Cursor from screen during experiment
    HideCursor;
    
    %Taille de l'écran en pixels
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    %Centre de l'écran
    [xCenter, yCenter] = RectCenter(windowRect);
    
    for compteur = 1:length(image_mat)
        %Image et mot qu'on présente dans ce qui serait normalement une
        %boucle qui parcours la matrice d'image et la matrice de mots
        image_presented = imread(image_mat(compteur));
        word_presented = veteur_non_mots(compteur);
        
        %Redimensionner l'image à un ratio à un ratio qui correspond au 1/3
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
        compteur+1;
    end
    %It is very important to always end a script with this command if drawing is involved to send control of the screen back to MATLAB.
        Screen('CloseAll');
elseif condition == 2
    
else
    disp("La condition entrée n'est pas valide. Veuillez entrer 1 ou 2, dépendamment de la condition");
    
end
