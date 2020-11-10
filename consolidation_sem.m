function consolidation_semantique = consolidation_sem

banque_mot = ["talège","ledompe","sanenla" ]; %banque mot, va voir ce lien pour générer des non-mots : http://www.fredericboutot.com/
images = 
myFolder = 'C:\Users\Dylan\Desktop\UdeM A20\programamation en Nsc cogni\images'; % variable pour le folder avec les images
imread(myFolder);
im = imread(myFolder,jpeg);

% des boucles pour stocker et lire nos images
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  imshow(imageArray);  % Display image.
  drawnow; % Force display to update immediately.
end


if true
   myFolder = dir('E:\ Folder\*.jpg'); 
   
   for i = 1 : length(myFolder)
       image'i'= imread()
       I{i} = imread(filename);
  end
end


%exemple_presentation_image
clc;
clear all;
close all;

screens=Screen('Screens');
screenNumber=max(screens);

%définir les coordonnées du centre de l'écran
%[screenXpixels, screenYpixels] = Screen('WindowSize', screenNumber);
%[xCenter, yCenter] = RectCenter(windowRect);

%This command seeds the random number generator so any generated numbers are truly "random"
rng('shuffle');

%Tells Screen to skip any synchronization tests. Ideally, you actually want to leave this line out. 
%However, it will most likely take you a lot of hardware tweaking to get your system to run without this command.
Screen('Preference','SkipSyncTests',1);

[window,window_size] = Screen('OpenWindow',screenNumber,[0 0 0],[],32,2);

%importer l'image de 'pomme'
abeille_image = imread('abeille.jpeg');

%dessiner la texture de 'pomme'
abeille_texture = Screen('MakeTexture',window,abeille_image);

Screen('DrawTexture',window,abeille_texture,[],[]);

%The flip command takes everything that has been drawn and actually pushes it to the display. 
%Without the flip command the images you draw will remain offscreen!
Screen('Flip',window);

%Attendre qu'on appuie sur une touche pour quitter
KbStrokeWait;

%It is very important to always end a script with this command if drawing is involved to send control of the screen back to MATLAB.
Screen('CloseAll');
