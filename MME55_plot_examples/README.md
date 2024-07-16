# Set-up

Run ProcessData.m to import all data from MME55_data.xlsx and process it correctly, and add the subfolders to path

## External functions needed:
- [boxplot_custom](https://www.mathworks.com/matlabcentral/fileexchange/87734-boxplots-custom)
- [linspecer](https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap)
- [padcat](https://www.mathworks.com/matlabcentral/fileexchange/22909-padcat)
- [Violin and violinplot](https://github.com/bastibe/Violinplot-Matlab)

## My custom functions needed:
- xdevs/xnames/xstats: extract subsets of deviations/functional names/stats (specific to this data set but could be modified)
- textab: general function for writing latex tables from matlab tables/arrays


# Examples

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
