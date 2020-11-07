function consolidation_semantique = consolidation_sem

banque_mot = ["talège","ledompe","sanenla" ]; %banque mot
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



