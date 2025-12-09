function objconstr = get_objconstr(x, f)
% This is a helper function for converting cost to objconstr format.
% Author: Volkan Kumtepeli

y = f(x);
cost1 = y;

if(cost1>5e8)
    objconstr.Fval = 1;
    objconstr.Ineq = 1;
else
    objconstr.Fval = y;
    objconstr.Ineq = -1;
end

end