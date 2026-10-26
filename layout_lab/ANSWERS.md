# CS442 Layout and Lifecycle Lab — Team Board

**Name:** Rafia Naeem  
**Roll Number:** 04072313032

## Numeric Answers

**A1:** 38  
**A2:** 7  
**A3:** 2  
**A4:** 50

## Written Answers

### B1: Which classes are Stateless and which are Stateful, and why?

`LabApp`, `SettingsCard`, `Probe`, `InfoPanel`, `SummaryRow`, `ShareRow`, `InfoBox`, and `StampStack` are StatelessWidgets because they do not manage changing data of their own. `HomePage`, `Clock`, `SwapBoard`, and `Tile` are StatefulWidgets because they need to update the screen when something changes. For example, the clock updates with time, the tiles count my clicks, and SwapBoard changes the order of the tiles.

### B2: Widget, Element, RenderObject — which one is rebuilt on every setState, and which ones are kept? What did Probe show?

When `setState()` is called, Flutter runs the affected widget's `build()` method again and creates updated widget configurations. Flutter usually keeps the existing Element when it can reuse it, and the RenderObject is generally updated rather than recreated. In my Probe output, the Widget identity changed during rebuilds, while the Element identity stayed the same. The Scaffold check displayed `true`, which showed that Probe was inside a Scaffold.

### B3: Explain “constraints go down, sizes go up” using your Step 7 or Step 8 example.

In Step 8, the Row tells its children how much space they can use. The `Expanded` button gets its allocated share of the remaining width, while the `Flexible` button can use less than its allocated space. Each child chooses a size within the given constraints, and that size information goes back up the layout tree. This is what “constraints go down, sizes go up” means.