function consolidation_semantique = consolidation_sem(condition)

%Fermer toutes les fenêtres, 
clc;
clear all;
close all;

%Amorce le générateur de nombres aléatoires afin que tous les nombres générés soient vraiment "aléatoires"
rng('shuffle');

screens=Screen('Screens');
screenNumber=max(screens);

%Ouvre une boîte de dialogue qui demande les informations du participant
%dans l'optique de stocker ses réponses avec ses informations à des fins d'analyse
prompt = ({'Code de participant:','Âge:'});
dlgtitle = 'Information du participant';
dims = [1 40; 1 40]
info_participant = inputdlg(prompt,dlgtitle,dims)

%Si la condition est '1', voici ce que la fonction exécutera:
% -> Présenter une paire non-mot + image, une à la fois à l’écran
% -> Après 5 secondes, la paire non-mot + image change pour la prochaine
if condition == 1
    veteur_non_mots = ["tâfethor" "nognurel" "sarybêt" "lenêcheg" "gecolêt" "gugareg" "labèlel" "ramomet" "gasafod" "yarevat" "lêmobur" "ceduphèc" "cosonem" "botamom" "fanisîr" "quytamaf" "cynofép" "poçamec" "kasifoc" "cémacèm"];
    image_mat = ["bleuet.jpg","brocheuse.jpg","brocoli.jpg","brocheuse.jpg","cafe.jpg","canape.jpg","carotte.jpg","ciseaux.jpg","fourmi.jpg","girafe.jpg","kiwi.jpg","lion.jpg","mojito.jpg","paresseux.jpg","pizza.jpg","stylo.jpg","succulente.jpg","tennis.jpg","velo.jpg"];
    
    [window,window_size] = Screen('OpenWindow',screenNumber,[0 0 0],[],32,2);
    
    for compteur = 1:image_mat.length
        image_presented = imread(image_mat(1))
    end
    
elseif condition == 2
    
else
    disp("La condition entrée n'est pas valide. Veuillez entrer 1 ou 2, dépendamment de la condition");
    
end
