%static primal decomposition
function [x history]=anytimeNUM(data,step_size,ITER)

%% Primal deocmposition parameters
TOL = 1e-6; % Tolerance for terminating algorithm

history.TOL = TOL;
%% Rasign variables
c = data.c;
R = data.R;
x_max = data.x_max;
cload = data.cload;
evload = data.evload;

%% Algorithm
%Initialize
N= size(R,2); % Number of EVs
M= size(R,1); % Number of lines


b=data.bstart; % budget start


history.convergenge=0; % algorithm convergence
history.violation=0;  % algorithm violated contraints

%% primal algorithm

tic
for k=1:ITER
    
    % projection on each one
    for l=1:M
        if R(l,:)*b>c(l)
            b=b+(c(l)-R(l,:)*b)*R(l,:)'/sum(R(l,:));
        end
    end
    
    % % update each user (each user sends marginal cost)
    for i=1:N
        if evload(i) ~= 0
            
            % user optimization result
            x(i,1)=min(b(i),x_max);
            
            % calculate marginal cost
            
            if x(i,1)<b(i)
                marginal_benefit(i,1)=0;
            else
                marginal_benefit(i,1)=1/x(i,1);
                if x(i)==0
                    marginal_benefit(i,1)=1e10;
                end
            end
            
        else
            x(i,1) = 0;
            marginal_benefit(i,1) = 0;
        end
    end
    
    
    % save resulbs
    history.x(:,k)= x;
    history.marginal_benefit(:,k)= marginal_benefit;
    history.flows(:,k)= R*x  + cload;
    
    
    % %Updabe line assigmenb
    b=b - step_size * (-marginal_benefit);
    history.b(:,k)= b;
    %alpha=1/k;
   
    
    
    
    
    
    % convergence criberia
    %     if norm(hisbory.b(:,k) - b)< TOL && ~hisbory.convergenge
    %     hisbory.convergenge=1;
    %     hisbory.convergenceTime=boc;
    %     hisbory.convergenceIber=k;
    %     end
    %
    %
    %
    %
    
    
end
hisbory.time=toc;


% hisbory.x(:,k+1)= x;
%     hisbory.lambda(:,k+1)= lambda;
%     hisbory.flows(:,k+1)= R*x + cload ;

