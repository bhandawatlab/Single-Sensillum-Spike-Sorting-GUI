# Single Sensillum Recording/Spike Sorting GUI

Graphical User Interface (GUI) used to:
1. Perform single sensillum recordings with user specified optogenetic stimulation.
2. Perform user guided spike sorting using wavelet transforms

## Getting Started

Download and add folder to path. Generate an stimulus file with the following variables:
1. fs: sampling rate (default set to 10000 if not present)
2. V: (1 x n) voltage (0-5) output of the stimulus (corresponding to intensity of optogenetic stimulus).
If you have multiple stimulus trains, you can set them as a cell array.

### Prerequisites

MATLAB

## Using the GUI

### Running the acquisition

1. Run MainGUI.m
2. Click on "Load Stim File"
3. If the stimulus file has multiple stimulus types, you can toggle between them using the center dropdown menu
4. Click on "Preview Stim" to visualize the stimulus trace
5. When you are happy with the stimulus train, click on "Run Experiment"
6. The experiment will be finished when the Current Status changes from "Running" to "Standby", 
7. Click on "Plot Experiment" to visualize the recorded data (See section below on plotting)
8. Click on "Save Experiment" to save the recorded data
9. Proceed with spike sorting steps (4-7) if desired

### Spike sorting

1. Run MainGUI.m
2. Click on "Load Data"
3. Click on "Plot Results"
4. Enter into the text boxes on the bottom right corner, the original cluster number of spikes that should be clustered together (up to 4 new clusters)
5. Click on updateCluster
6. If unsatisfied, click on "Plot Results" to reset clusters and repeate steps 4 and 5
7. In satisfied, click on "Save Experiment"

### Plotted images

The main graph (top left) will show
1. The stimulus train in V when "Preview Stim" is selected
2. The Baseline Subtracted Neuron Response (blue line) with the stimulus train (black line (note that this will be in V)), and peaks of action potentials color coded by cluster

The subgraphs (6 right subplots) will show
1. The spikes belonging to each respective cluster superimposed upon each other


## Authors

* **Liangyu Tao**
