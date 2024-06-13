# Set-up

Run ProcessData.m to import all data from MME55_data.xlsx and process it correctly, and add the subfolders to path

Custom functions boxplot_custom, linspecer, padcat, Violin and violinplot are required for these scripts; their licenses are included in the folder.

My personal functions: xdevs/xnames/xstats are used to extract specific functionals' results from the MME55 data set, textab writes latex tables

# Scripts

1. Simple or grouped bar charts
2. Overlaid bar charts
3. Basic boxplot using boxplot_custom
4. Clustered boxplot for comparing data sets
5. Boxplots with coloured subsets using brute force methods lol
6. Basic violin plot
7. Violin plots with gaps between sections
8. Violin plots with each point in the scatter plot coloured separately
9. Violin plots with coloured labels using latex text commands
10. Using tiled layout to make equal-width sections in what looks like one set of axes
11. Using tiled layout to overlay two sets of axes
12. Generate a latex table from a MATLAB table or array
