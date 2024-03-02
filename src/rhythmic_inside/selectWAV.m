function wavFilePath = selectWAV()

% Open a GUI dialog to select a WAV file if no arguments are provided
[fileName, pathName] = uigetfile('*.wav', 'Select the WAV file');
if isequal(fileName,0) || isequal(pathName,0)
  disp('User canceled the operation.');
  return;
else
  wavFilePath = fullfile(pathName, fileName);
  disp(['User selected: ', wavFilePath]);
end

end
