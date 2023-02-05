# Spatial Simulation Final Project

## Flooding Simulation in Campos dos Goytacazes, Rio de Janeiro, Brazil.

[Rodrigo Brust Santos](rodrigobrust.com)

[Prof. Gudrun Wallentin](https://www.plus.ac.at/geoinformatik/fachbereich/team/wallentin/)

_______

### Table of Contents

1. [Introduction](#introduction)

2. [Objectives](#objectives)

3. [Methodology](#methodology)

4. [Results](#results)

5. [Discussions](#discussion)

6. [Conclusions](#conclusions)

7. [References](#references)


______

## 1. Introduction  <a name="introduction"></a>

This report is a final project of the Spatial Simulation course, taken in the winter semester of 2022/23. The course is taught by
Prof. Gudrun Wallentin covers a lot of definitions and practical exercises of event simulation. To develop such simulations an open-source software called Gama was used.

### Introduction to Spatial Simulation

Nowadays, it is very common to say “data is the new oil”. Such a sentence refers to the fact 
that oil is not as valuable as data – from where you can take infinite information and drive your business in the desired direction.

Knowing what your consumer enjoys, understanding the behavior of animals, and trying to
predict the optimal time for maintenance in a machine are simple examples of data-driven strategies 
that all industries are dipped in.

However, in some cases, data is not available. Perhaps this happens because it wasn’t 
discovered how to collect data, or even. After all, the process of data collection is expensive and time-consuming. This is where simulation takes place, especially when we add a spatial component – and also time.

Spatial simulation is the field of geoscientific studies that takes information from the real world, 
simplify it, and creates models expecting outputs that could complement the reality in a scenario that 
was not seen yet. With such a strategy, it is feasible to create synthetic data near reality or even 
find answers to patterns that the final result is not palpable.

Such a field of study has applications in several problems, from urban planning to geologic and 
natural processes. That is why it is an extremely effective tool for spatial studies. 

### Flooding Simulation

Climate Change is a process that every day is taking one step further owing to
human activities. Due to the lack of proper action from our leaders, the
situation is getting closer to the un-return point. 

In other words: once we achieve it, there is no way of going back and saving our planet. In these
scenario governments, scientists, and society must be ready for the consequences of climate change. 

One of these scenarios is a flood as a result of heavy rains in a small amount of period. This type of event is becoming more
common, impacting not only a city's infrastructure but also its residents.

Campos dos Goytacazes, a city located in the northwestern part of Rio de Janeiro State, Brazil, is one of these cities that
often suffer from flooding. Placed in the riverbanks of Paraíba do Sul river, Campos plays a major role in the regional economy - that every once in a while is affected by heavy summer storms, that lead to river floodings.

Having this brief overview in mind, it is possible to rise the following question: **how much of Campos dos Goytacazes is
affected by flooding events?**

______

## 2. Objectives  <a name="objectives"></a>

For this project, the main objective is to see which areas of Campos are flooded. For that, the GAML programming language was used. 

Having a flooding simulation helps several organizations to better plan the city and avoid risky areas. Also, it will assist in case of forecasting extreme events, allowing public power to send early warnings.

_______

## 3. Methodology  <a name="methodology"></a>

The development of this project had 3 main phases: **data collection and pre-processing**, **building the simulation**, and finally the **validations**. Let's dig deeper into each of these steps.

______

### Data Collection & Pre-processing

- Urban data: the street network was downloaded from OpenStreetMap using the QGIS plug-in QuickOSM.

- River Data: there are two main types of data related to the river:
    
    - River polygon: the river polygon was generated from a CBERS4A image segmentation. After downloading it from Instituto de Pesquisa Espaciais (INPE), the image was composited and then segmented. All segments that were within the river area and had similar values were filtered, leading to a river polygon.

    - River Height Measures: in Brazil, the Brazilian National Water Agency (Agência Nacional de Águas - ANA) is responsible for measuring rivers' flow and height. Through HydroBR API, a Python library API, it was possible to select and filter all information for Campos dos Goytacazes. With this resource, it was possible to establish the mean height for Paraíba do Sul river in the study area, which was 6.8m at the `CAMPOS - PONTE MUNICIPAL` fluviometric station from 1922 to 2019. Such information is important because will help understand how much water the area can support, and how long it will take to go above the flooding height, which is 10.4m, according to the last events measured by technical teams from Campos do Goytacazes City Hall.

- Digital Elevation Model (DEM): the DEM has a 30m pixel resolution. It was downloaded from TOPODATA, an INPE platform for surface models. Using QGIS, it was necessary to perform an altitude subtraction process. From all cells within the river polygon, a subtraction of -3 was performed to make the river depth more representative. With this process, would then be possible to match the river's overflow quota, making the simulation more realistic.  

![fluxogram](https://user-images.githubusercontent.com/53950449/215608121-bcacffa3-d43a-4a36-93ff-108005bba98d.jpg)


______

### Building Simulation

To build the flood simulation was used the main structure of Gaudou (n.d) code available in the Gama Platform was. 

The code has a model definition section (model camposfloodingmodel) and a global section that contains variables, functions, and reflexes. The code uses a DEM file, a river shape file, and a road geojson file as input to define the environment, shape of the environment, and roads.

The global section contains variables such as ``diffusion_rate``, `drain_cells`, ``source_cells``, and ``input_water``. It also contains functions like init_cells to initialize the altitude of cells, init_water to initialize the height of water in the cells and flow to simulate the flow of water from one cell to another.

Several reflexes perform various functions. The ``add_water_input`` reflex adds water to the source cells, and the ``add_input_water `` reflex adds water to the source cells, the flowing reflex simulates the flow of water based on altitude and obstacles. The ``update_cell_color`` reflex updates the color of cells, and the `draining` reflex drains water from the other cells.

The grid section of the code defines the properties of the cells in the grid and contains an action flow to simulate the flow of water.

Each cell that was flooded receives a value of `1`. After this value assignment, a raster is exported, allowing the comparison with other research developed in the regions.

____

### Validation


For data validation, it was possible to use the following research projects:

- MapBiomas Água (Souza et al., 2020) is a platform that allows you to analyze water data from 1985 until 2022, showing which locations had gained and lost water, besides seasonal transitions. 

- Based on Pekel et al. (2016), the Surface water occurrence probability allows you to check the probability of water occurrence near-by the river banks.

The data from Pekel et al. (2016) is also avaible at Tomislav et al. (2019) platafom called OpenLandMap.

The idea was to compare the simulation output cells to the data provided in the previous works and check how accurate the simulation was.

Three scenarios will be taken into consideration regarding the river level:

- Mean of river level (6.78m)

- Mean + 1std of river level = 7.88m

- Mean - 1std of river leval = 5.69m

Also, there will be a limit of 1000 cycles and the diffusion rate will be constantly at 0.8. With all these three overviews, a more realistic understanding of flood regime fluctuations can be achieved.
______

## 4. Results  <a name="results"></a>

Taking into consideration the premise aforementioned, we had the following outputs:

|Simulation| Output|
|-----|-----|
|Mean| ![image](https://user-images.githubusercontent.com/53950449/216840373-1d914d2f-1a3c-4d10-9122-7587c1e82df9.png)|
|Mean + 1 std| ![image](https://user-images.githubusercontent.com/53950449/216840382-d54756d5-cc7e-4f42-bee5-39d5ad8e2a9d.png)|
|Mean - 1 std| ![image](https://user-images.githubusercontent.com/53950449/216840396-c5db9c8f-24f6-44db-b78b-1a88bb7db223.png)|

The water input cells kept flooding the river channel constantly. All water flow that was not heading to the main channel, would then go to the flat lands nearby - located in the upper-left and lower-left parts of the simulation. 

In all three scenarios, the SW part of the city was severely flooded. Also, some regions near the river banks and some lakes were damaged. Following the simulation, about 5 to 10% of the city region is very prone to flood areas.


______

## 5. Discussion  <a name="discussion"></a>


The first thing flaw it is possible to see in the simulation is the number of flooded cells around the river water source - located in the very first left cells in the model. 

Naturally, these areas are flat and might happen to have small seasonal lakes, just as shown in the [MapBiomas Water Plataform](https://plataforma.agua.mapbiomas.org/water/-21.734937/-41.277721/10.6/biome/4/biome/surface/1985/2022) (Souza et al., 2020). However, because this simulation model has no drainage system, without infiltration or evaporation, the cells get flooded and only increase in volume.

Even though this flaw exists, there are a few interesting points that are worth mentioning, and if better developed, will reflect the reality similarly.

- Comparing with water occurrence probability (Pekel et al., 2016), the model shows satisfactory results, with a near-the-reality scenario. The river's main channel, the lakes, and flooded areas have been properly flooded in the simulation

|Model Mean | Pekel et al., 2016 |
|------|--------------------|
|  ![image](https://user-images.githubusercontent.com/53950449/216840373-1d914d2f-1a3c-4d10-9122-7587c1e82df9.png) |          ![image](https://user-images.githubusercontent.com/53950449/216840439-795ef57e-00a9-48a0-8d7d-b33dc061d0f7.png)|


- The GIF below, produced in the MapBiomas Platform (Souza et al., 2020) shows the evolution of the amount of water in water bodies for the Campos dos Goytacazes area. It is possible to see there are wet and dry seasons, evidenced by the amount of water present in the lakes, flood plains, and also in the river. 

![WaterEvolution_1985-2022](https://user-images.githubusercontent.com/53950449/216840463-fb4d064b-33e1-413f-8e24-87f564556596.gif)


- Now, comparing the average from 1985 to 2022 of water occurrence with the flood simulation, once again, the results are quite acceptable. Except for the super-flooded area in the SW and NW parts of the city, the whole flooded cells are quite related to each other.

|Model Mean | Souza et al., 2020 |
|------|--------------------|
|  ![image](https://user-images.githubusercontent.com/53950449/216840373-1d914d2f-1a3c-4d10-9122-7587c1e82df9.png) | ![image](https://user-images.githubusercontent.com/53950449/216840808-9059c968-05c4-4155-9457-8db5e7e0ed75.png)|

_____

## 6. Conclusions  <a name="conclusions"></a>

In summary, the flooding simulation for Campos dos Goytacazes presented an alluring result if taken into consideration the simplicity of the model developed. 

The approaches used were an attempt to bring the simulation closer to reality, using real data for validating it. 

The model can be built with more complexity, making the flaws disappear. Evapotranspiration rate and soil absorption are a few of the new features that can be designed within the code.

Nonetheless, the simulation still brings some topics that might be interesting for city planners and city hall personnel. Areas such as the ones that got extremely flooded in the simulation show that in extreme cases these regions might be more affected than the others.


_____

## 7. References  <a name="references"></a>


Gaudou, B. (n.d).  Water flow in a river is represented by a set of cells, depending on the elevation. Gama Platform.

OpenStreetMap contributors. (2015). Campo dos Goytacazes street network [Data file]. Retrieved from https://planet.openstreetmap.org

Taillandier, P., Gaudou, P. Grignard, A. Huynh, Q.N., Marilleau, N., Caillou, P., Philippon, D., Drogoul, A. (2018) Building, Composing and Experimenting Complex Spatial Models with the GAMA Platform. GeoInformatica, Dec. 2018. https://doi.org/10.1007/s10707-018-00339-6.

Pekel, J. F., Cottam, A., Gorelick, N., & Belward, A. S. (2016). High-resolution mapping of global surface water and its long-term changes. Nature, 540(7633), 418. http://dx.doi.org/10.1038/nature20584

QGIS.org (2022). QGIS Geographic Information System. QGIS Association. http://www.qgis.org

Souza et al. (2020) - Reconstructing Three Decades of Land Use and Land Cover Changes in Brazilian Biomes with Landsat Archive and Earth Engine - Remote Sensing, Volume 12, Issue 17, 10.3390/rs12172735

Tomislav, H., Collins, T. N., Wheeler, I., & MacMillan, R. A. (2019). Everybody has a right to know what’s happening with the planet: towards a global commons. Medium (Towards Data Science), http://doi.org/10.5281/zenodo.2611127
_____
