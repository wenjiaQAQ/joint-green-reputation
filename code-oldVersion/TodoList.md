## TODO
- Add JR calculation function [done]
- Update main and other functions with jrCalculate.m [done]
- Test strategyFirstPlan []

- Finish testing
- Remove all display functions
- Redesign the simulation experiments
- Subset greenTransDyn (specific parameter setting) unction out from main
- Realize idea2 in strategyFirstPlan2.m

### Please check the following:
- Main.m, line 14, do we need var initialT2GValues to be global?
- Main.m, line 16, 77, 79, var initialJRValues can be removed?
- Main.m, line 84, I remove all the inputs of function strategyFirstPlan() because if you already define those var as global,
as long as you assert the global variables, you do not need to use the parameters and arguments to transfer their values. 
All functions can get access to the global variables as long as you assert the variables within the function.
- StrategyFirstPlan.m, has a problem, it break links for nodes who has more than 5 neighbors, but for manufacturer, their max neighbor is 10;
they shouldn't break links when numNeighbors > 5. I have wrote a function StrategyFirstPlan.m. I have checked, please check again.


## Simulation result ana


## Empirical data ana

