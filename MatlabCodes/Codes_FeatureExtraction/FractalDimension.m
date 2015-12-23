%% Function to calculate the fractal dimenstions

%     1. Box-Counting(Haus) (BC)
%     2. Differential Box-Counting (MBC)
%     3. Triangular Prism Surface Area (TPSA)



% Input Parameters:     - InputImage: A 2D Image
%                       - PlotFlag: A flag to show the plots or not. 
%                         It should set to 1 to visualize the
%                         results

% Output Parameter:     - Output: A vector of 1x30 real values
%                         FD_BC , FD_MBC, FD_TPSA are real values
%                         representing the Box-Counting(Haus), Modified (Differential)
%                         box-counting and Triangular Prism Surface Area fractal dimentions.
%                         - FD_BC : BC fractal dimension (The slope of best
%                         fitted line)
%                         - FD_MBC : MBC fractal dimension (The slope of best
%                         fitted line)
%                         - FD_TPSA : TPSA fractal dimesion (The slope of best
%                         fitted line)
%                         - FDMat_BC : BC fractal dimension for all resolusions
%                         - FDMat_MBC : MBC fractal dimension for all resolusions
%                         - FDMat_TPSA : TPSA fractal dimension for all resolusions



function Output = FractalDimension(InputImage,PlotFlag)

I =InputImage;

dim = ndims(I); 
if dim > 2
    error('Maximum dimension should be 2.');
end


% Spliting the Image into the small grids and copute the fractal dimension


% The largest size of the box
width = 256;    
p = log(width)/log(2);   
p=8;
% If the size of images is not powe of 2, rescale the images,
% if p~=round(p) || any(size(I)~=width)
%     p = floor(p);
%     width = 2.^p;
%     RescaledI = zeros(width, width);
%     RescaledI(1:size(I,1), 1:size(I,2)) = I;
% end
% figure , imshow(RescaledI,[])
RescaledI = imresize(I,[256 256]);


% Allocation of the number of box size
n = zeros(1,p+1); 
counter=0;
counter_dbc = 0;
counter_tpsa =0;
step = width./2.^(1:p);
testim =[];

%------------------- 2D boxcount ---------------------%
for n = 1:1:size(step,2)
    stepnum = step(1,n);
    for i = 1: stepnum:width 
        for j = 1: stepnum:width
            
            % Get the Grid in each level
            testim = RescaledI(i:i +stepnum-1,j:j +stepnum-1);
            
            % Differential(Modified) Box Counting
            MaxGrayLevel = max(max(testim));
            MinGrayLevel = min(min(testim));
            GridCont = MaxGrayLevel-MinGrayLevel+1;
            counter_dbc = counter_dbc + GridCont;
            % Differential(Modified) Box Counting (MBC)
            
            %Triangular Prism Surface Area (TPSA)
            a = testim(1,1);
            b = testim(1,end);
            c = testim(end,1);
            d = testim(end,end);
            e = (a+b+c+d)/4;
            
            w = sqrt(((b-a)^2) + (stepnum^2));
            x = sqrt(((c-b)^2) + (stepnum^2));
            y = sqrt(((d-c)^2) + (stepnum^2));
            z = sqrt(((a-d)^2) + (stepnum^2));
            
            o = sqrt(((a-e)^2) + (0.5*stepnum^2));
            p2 = sqrt(((b-e)^2) + (0.5*stepnum^2));
            q = sqrt(((c-e)^2) + (0.5*stepnum^2));
            t = sqrt(((d-e)^2) + (0.5*stepnum^2));
            
            % Using Herons Formula
            
            sa = (w+p2+o)/2;
            sb = (x+p2+q)/2;
            sc = (y+q+t)/2;
            sd = (z+o+t)/2;
            
            % Areas of Traiangle
            
            S_ABE = sqrt((sa)*(sa-w)*(sa-p2)*(sa-o));
            S_BCE = sqrt((sb)*(sb-x)*(sb-p2)*(sb-q));
            S_CDE = sqrt((sc)*(sc-q)*(sc-t)*(sc-y));
            S_DAE = sqrt((sd)*(sd-z)*(sd-o)*(sd-t));
            SurfaceArea = S_ABE + S_BCE + S_CDE + S_DAE;
            counter_tpsa = counter_tpsa + SurfaceArea;
            %Triangular Prism Surface Area

            
            % Basic Box Counting (BC)
            if (size(find(testim~=0),1)~=0)
                counter = counter+1;
            end	
            % Basic Box Counting
            
        end
    end
    N_mbc (1,n) = counter_dbc;
    N_tpsa (1,n) = counter_tpsa;
    N_b(1,n) = counter;
    counter = 0;
    counter_dbc = 0;
    counter_tpsa = 0;
    n=n+1;
end

% Box-Count values
N_b; 
N_mbc; 
N_tpsa;


% Resolusion
r0 = (2.^(p:-1:1));

% Dimension of BC
x0 = log(r0);
y0 = log(N_b);
FDMat_BC = (y0)./(x0);
D0 = polyfit(x0, y0, 1);
FD_BC = D0(1);

% Dimension of MBC
x1 = log(r0);
y1 = log(N_mbc);
FDMat_MBC = (y1)./(x1);
D1 = polyfit(x1, y1, 1);
FD_MBC = D1(1);

% Dimension of MBC
x2 = log(r0);
y2 = log(N_tpsa);
FDMat_TPSA = (y2)./(x2);
D2 = polyfit(x2, y2, 1);
FD_TPSA = 2 - D2(1);

% Plotting

if PlotFlag ==1

% Figure 1
f0 = polyval(D0,x0);
figure, plot(x0,y0,'-*','color','b','LineWidth',1.5)
grid
hold on, plot(x0,f0,'-*','color','k','LineWidth',1.5)
legend('The FD Line','The Best Fitted Line','Location','NorthEast')
xlabel('log(r)')
ylabel('log(N)')

% Figure 2
f1 = polyval(D1,x1);
figure, plot(x1,y1,'-*','color','b','LineWidth',1.5)
grid
hold on, plot(x1,f1,'-*','color','k','LineWidth',1.5)
legend('The FD Line','The Best Fitted Line','Location','NorthEast')
xlabel('log(r)')
ylabel('log(N)')

% Figure 3
f2 = polyval(D2,x2);
figure, plot(x2,y2,'-*','color','b','LineWidth',1.5)
grid
hold on, plot(x2,f2,'-*','color','k','LineWidth',1.5)
legend('The FD Line','The Best Fitted Line','Location','NorthEast')
xlabel('log(r)')
ylabel('log(N)')
end


Output = [FD_BC , FD_MBC, FD_TPSA, FDMat_BC, FDMat_MBC, FDMat_TPSA];
