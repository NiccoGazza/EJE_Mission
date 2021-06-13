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
    body = ["planets/mercury.jpg" 
            "planets/venus.jpg" 
            "planets/earth.jpg" 
            "planets/mars.jpg" 
            "planets/jupiter.jpg" 
            "planets/saturn.jpg" 
            "planets/uranus.jpg" 
            "planets/neptune.jpg" 
            "planets/pluto.jpg"  
            "/planets/sun.jpg"];
        
    radii = [2439.7
             6051.8 
             6371
             3389.5
             69911
             58232
             25362
             24622
             1151
             262.7
             476.2
             695508]; %[km]
         
	R = radii(obj_id); %[km]
    
    %% Sphere creation
    [xx,yy,zz] = sphere(100);
    sp_hand = surface(obj_pos(1)+R*xx/1.5, obj_pos(2)+R*yy/1.5, obj_pos(3)+R*zz/1.5);
    
    %% Surface change
    img = imread(body(obj_id));
    
	tform = affine3d(...
			[[1 0 0; 0 -1 0; 0 0 1], [0 0 0]'; 0 0 0 1] );
		
	img = imwarp(img,tform);
	
    set(sp_hand,'facecolor','texture',...
        'cdata',im2double(img),...
        'edgecolor','none');
    
end