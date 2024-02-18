function score = IGD(PopObj,optimum)
% <min>
% Inverted generational distance
% 输入：
%       求得的Pareto前沿，真实Pareto前沿
% 输出：
%       hv值

%------------------------------- Reference --------------------------------
% C. A. Coello Coello and N. C. Cortes, Solving multiobjective optimization
% problems using an artificial immune system, Genetic Programming and
% Evolvable Machines, 2005, 6(2): 163-190.
%--------------------------------------------------------------------------


    if size(PopObj,2) ~= size(optimum,2)
        score = nan;
    else
        score = mean(min(pdist2(optimum,PopObj),[],2));
    end
end