function body_sphere(obj_id,obj_pos)
% BODY_SPHERE(obj_id,rr) plots a sphere at coordinates OBJ_POS
%   and applies the image of OBJ_ID body to its surface.
%   Available: all solar planets, Pluto, Vesta, Ceres, Sun.
%
%   obj_id   - numeric identifier of the target body (1-12)
%
%   obj_pos  - (x,y,z) coordinates of target body, wrt the Sun
%

    %% Constants
    global radii
    body = ["planets/mercury.jpg" 
            "planets/venus.jpg" 
            "planets/earth.jpg" 
            "planets/mars.jpg" 
            "planets/jupiter.jpg" 
            "planets/saturn.jpg" 
            "planets/uranus.jpg" 
            "planets/neptune.jpg" 
            "planets/pluto.jpg"
            "planets/pluto.jpg"
            "planets/sun.jpg"];
     
	R = radii(obj_id); %[km]
    
    %% Sphere creation
    [xx,yy,zz] = sphere(100);
    if(obj_id == 11)
        sp_hand = surface(obj_pos(1)+R*xx*50, obj_pos(2)+R*yy*50, obj_pos(3)+R*zz*50);
    elseif(obj_id == 5)
        sp_hand = surface(obj_pos(1)+R*xx, obj_pos(2)+R*yy, obj_pos(3)+R*zz);
    else
        sp_hand = surface(obj_pos(1)+R*xx/1.5, obj_pos(2)+R*yy/1.5, obj_pos(3)+R*zz/1.5);
    end
    %% Surface change
    img = imread(body(obj_id));
    
	tform = affine3d(...
			[[1 0 0; 0 -1 0; 0 0 1], [0 0 0]'; 0 0 0 1] );
		
	img = imwarp(img,tform);
	
    set(sp_hand,'facecolor','texture',...
        'cdata',im2double(img),...
        'edgecolor','none');
    
end