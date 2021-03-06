% RenderSet addition function
% ver.2020.10.01
% requires AntiNormalConvertor_Mk1.m
% by AstreTunes@SEA-group

function primCodeKai = PrimitivesAppend_Mk1(primCode, chunkName)

    %% Read sectionName part
    
    primCodeLength=length(primCode);

    sectionNamesSectionLength=primCode(primCodeLength) * 256^3 + primCode(primCodeLength - 1) * 256^2 + primCode(primCodeLength - 2) * 256 + primCode(primCodeLength - 3);
    sectionNamesSectionStart=primCodeLength - 4 - sectionNamesSectionLength + 1;
    sectionNamesSectionEnd=primCodeLength - 4;

    cursor=sectionNamesSectionStart;
    sectionCount=0;

    while cursor < sectionNamesSectionEnd

        sectionCount=sectionCount+1;

        % get the length of the coresponding section
        sectionSize(sectionCount)=primCode(cursor + 3) * 256^3 + primCode(cursor + 2) * 256^2 + primCode(cursor +1) * 256 + primCode(cursor);

        % get the unknown 16 bytes
        sectionUnknown{sectionCount}=primCode(cursor+4 : cursor+4+15);

        % get the length of the section's name
        cursor=cursor+4+16;
        currentSectionNameLength=primCode(cursor + 3) * 256^3 + primCode(cursor + 2) * 256^2 + primCode(cursor +1) * 256 + primCode(cursor);
        currentSectionNameLength=4*ceil(currentSectionNameLength/4);

        % get the section's name
        cursor=cursor+4;
        sectionName{sectionCount}=native2unicode(primCode(cursor: cursor+currentSectionNameLength-1)');

        % get the section type
        sectionClass{sectionCount}=sectionName{sectionCount}((strfind(sectionName{sectionCount}, '.')+1): end);
        sectionTitle{sectionCount}=sectionName{sectionCount}(1: (strfind(sectionName{sectionCount}, '.')-1));

        cursor=cursor+currentSectionNameLength;

    end

    % the following three lines are not necessary, but I prefer vertical arrays :)
    sectionSize=sectionSize';
    sectionClass=sectionClass';
    sectionTitle=sectionTitle';

    clear cursor sectionCount currentSectionNameLength sectionName;

    % set sectionSize to multiple of 4
    for indSect = 1:size(sectionSize, 1)

        sectionSize(indSect) = 4*ceil(sectionSize(indSect)/4);

    end
    
    %% Check vertex sections and look for iiiww
    
    isSkinned = 0;
    cursor = 4;
    
    for indSect = 1:length(sectionSize)
        
        if contains(sectionClass{indSect}, 'vertices')
            if isequal(primCode(cursor+1: cursor+11), [120 121 122 110 117 118 105 105 105 119 119]')   % if the type starts by xyznuviiiwwtb
                isSkinned = 1;
            end
        end
        
        cursor = cursor + 4*ceil(sectionSize(indSect)/4);
        
    end

    %% Add additional sections

    primCodeKai = primCode;
    cursor = 4 + sum(sectionSize);

    % add vertex section
    if isSkinned

        primCodeKai(cursor+1 : cursor+13) = [120 121 122 110 117 118 105 105 105 119 119 116 98]';  % xyznuviiiwwtb 
        primCodeKai(cursor+14 : cursor+64) = zeros(51, 1);  % fill "vertex type" string
        primCodeKai(cursor+65 : cursor+68) =  [3 0 0 0];    % vertices count
        cursor = cursor + 68;

        % write the first vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(1), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(0), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 29) = [0 0 0 0 0];    % iiiww
        primCodeKai(cursor+30 : cursor + 33) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+34 : cursor + 37) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 37;

        % write the second vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(0), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(1), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 29) = [0 0 0 0 0];    % iiiww
        primCodeKai(cursor+30 : cursor + 33) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+34 : cursor + 37) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 37;

        % write the third vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(0), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(0), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 29) = [0 0 0 0 0];    % iiiww
        primCodeKai(cursor+30 : cursor + 33) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+34 : cursor + 37) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 37;

        vertexSectionLength = 4*ceil((68+37+37+37)/4);
        primCodeKai(cursor+1) = 0;
        cursor = cursor + 1;

    else

        primCodeKai(cursor+1 : cursor+8) = [120 121 122 110 117 118 116 98]';  % xyznuvtb 
        primCodeKai(cursor+9 : cursor+64) = zeros(56, 1);  % fill "vertex type" string
        primCodeKai(cursor+65 : cursor+68) =  [3 0 0 0];    % vertices count
        cursor = cursor + 68;

        % write the first vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(1), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(0), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 28) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+29 : cursor + 32) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 32;

        % write the second vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(0), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(1), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 28) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+29 : cursor + 32) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 32;

        % write the third vertex
        primCodeKai(cursor+1 : cursor + 4) = typecast(single(0), 'uint8');    % x
        primCodeKai(cursor+5 : cursor + 8) = typecast(single(0), 'uint8');    % y
        primCodeKai(cursor+9 : cursor + 12) = typecast(single(0), 'uint8');    % z
        primCodeKai(cursor+13 : cursor + 16) = AntiNormalConvertor_Mk1(0, 0, 1);    % n
        primCodeKai(cursor+17 : cursor + 20) = typecast(single(0), 'uint8');    % u
        primCodeKai(cursor+21 : cursor + 24) = typecast(single(0), 'uint8');    % v
        primCodeKai(cursor+25 : cursor + 28) = AntiNormalConvertor_Mk1(0, 1, 0);    % t
        primCodeKai(cursor+29 : cursor + 32) = AntiNormalConvertor_Mk1(1, 0, 0);    % b
        cursor = cursor + 32;

        vertexSectionLength = 4*ceil((68+32+32+32)/4);

    end

    % add index section
    primCodeKai(cursor+1 : cursor+6) = [108 105 115 116 0 0]';  % list
    primCodeKai(cursor+7 : cursor+64) = zeros(58, 1);  % fill "index type" string
    primCodeKai(cursor+65 : cursor+68) =  [3 0 0 0];    % indice count
    primCodeKai(cursor+69 : cursor+72) =  [1 0 0 0];    % group count
    cursor = cursor + 72;
    primCodeKai(cursor+1 : cursor+2) = [0 0];   % index 1
    primCodeKai(cursor+3 : cursor+4) = [1 0];   % index 2
    primCodeKai(cursor+5 : cursor+6) = [2 0];   % index 3
    cursor = cursor + 6;
    primCodeKai(cursor+1 : cursor+4) = typecast(uint32(0), 'uint8');  % group start index
    primCodeKai(cursor+5 : cursor+8) = typecast(uint32(1), 'uint8');  % group triangles count
    primCodeKai(cursor+9 : cursor+12) = typecast(uint32(0), 'uint8');  % group start vertex
    primCodeKai(cursor+13 : cursor+16) = typecast(uint32(3), 'uint8');  % group vertices count
    cursor = cursor + 16;

    indexSectionLength = 4*ceil((72+6+16)/4);
    primCodeKai(cursor+1 : cursor+2) = [0, 0]';
    cursor = cursor + 2;

    %% Write sectionNames

    originalSectionNames = primCode(sectionNamesSectionStart : sectionNamesSectionEnd);
    newSectionNamesSectionStart = cursor + 1;
    primCodeKai(cursor+1 : cursor+sectionNamesSectionLength) = originalSectionNames;
    cursor = cursor+sectionNamesSectionLength;

    % add vertex sectionName
    primCodeKai(cursor+1 : cursor+4) = typecast(uint32(vertexSectionLength), 'uint8');  % section size
    primCodeKai(cursor+5 : cursor+20) = zeros(16, 1);   % section unknown(0)
    nameLength = length([chunkName, '.vertices']);
    primCodeKai(cursor+21 : cursor+24) = typecast(uint32(nameLength), 'uint8');  % section name length
    primCodeKai(cursor+25 : cursor+24+nameLength) = unicode2native([chunkName, '.vertices']);
    cursor = cursor+24+nameLength;
    % check if length is multiple of 4
    switch mod((24+nameLength), 4)
        case 1
            primCodeKai(cursor+1 : cursor+3) = [0 0 0]';
            cursor = cursor+3;
        case 2
            primCodeKai(cursor+1 : cursor+2) = [0 0]';
            cursor = cursor+2;
        case 3
            primCodeKai(cursor+1) = 0;
            cursor = cursor+1;
        otherwise
    end

    % add index sectionName
    primCodeKai(cursor+1 : cursor+4) = typecast(uint32(indexSectionLength), 'uint8');  % section size
    primCodeKai(cursor+5 : cursor+20) = zeros(16, 1);   % section unknown(0)
    nameLength = length([chunkName, '.indices']);
    primCodeKai(cursor+21 : cursor+24) = typecast(uint32(nameLength), 'uint8');  % section name length
    primCodeKai(cursor+25 : cursor+24+nameLength) = unicode2native([chunkName, '.indices']);
    cursor = cursor+24+nameLength;
    % check if length is multiple of 4
    switch mod((24+nameLength), 4)
        case 1
            primCodeKai(cursor+1 : cursor+3) = [0 0 0]';
            cursor = cursor+3;
        case 2
            primCodeKai(cursor+1 : cursor+2) = [0 0]';
            cursor = cursor+2;
        case 3
            primCodeKai(cursor+1) = 0;
            cursor = cursor+1;
        otherwise
    end

    newSectionNameLength = cursor + 1 - newSectionNamesSectionStart;

    %% Write sectionNameLength

    primCodeKai(cursor+1: cursor+4) = typecast(uint32(newSectionNameLength), 'uint8'); 

end
