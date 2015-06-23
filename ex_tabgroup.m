function [a,b,c,d] = ex_tabgroup 
% This R2010b code does not use 'v0' syntax and updates properties

hf = figure;
a = uitabgroup('Parent',hf);        % Do not use the 'v0' argument
b = uitab('parent',a,'title','Breakfast');
c = uitab('parent',a,'title','Lunch');
d = uitab('parent',a,'title','Dinner');
set(a,'SelectionChangeCallback',...  % Formerly SelectionChangeFcn
    @(obj,evt) selectionChangeCbk(obj,evt));
set(a,'SelectedTab',b);          % Replaces SelectedIndex property

function selectionChangeCbk(src,evt) 
% This new code uses tab handles to directly access tab properites

oldTab = evt.OldValue;                % Event member is tab handle
oldName = get(oldTab,'title');        % Access child tab directly
newTab = evt.NewValue;                % Event member is tab handle
newName = get(newTab,'title');        % Access child tab directly
disp(['It was ' oldName ' time; now it is ' newName ' time.'])