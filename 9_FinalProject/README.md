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

5. [Discussions](#discussions)

6. [Conclusions](#conclusions)

7. [References](#references)


______

## 1. Introduction  <a name="introduction"></a>

This report is a final project of Spatial Simulation course, taken in the winter semester of 2022/23. The course is taught by
Prof. Gudrun Wallentin, covering a lot of definitions and practical exercises of event simulation. To develop such simulations an open-source software called Gama was used.

### Introduction to Spatial Simulation

Nowadays, it is very common to say “data is the new oil”. Such a sentence refers to the fact 
that oil is not as valuable as data – from where you can take infinite information and drive your business to the desired direction.

Knowing what your consumer enjoys, understanding the behavior of animals and trying to
predict the optimal time for maintenance in a machine are simple examples of data-driven strategies 
that all industries are dipped in.

However, in some cases, data is not available. Perhaps this happens because it wasn’t 
discovered how to collect data, or even because the process of data collect is expensive and timeconsuming. This is where simulation takes place, especially when we add a spatial component – and also time.

Spatial simulation is the field of geoscientific studies that takes information from real world, 
simplify it and create models expecting outputs that could complement the reality in a scenario that 
was not seen yet. With such strategy, it is feasible to create synthetic data near the reality, or even 
finding answers to patterns that the final result is not palpable.

Such field of study has applications in several problems, from urban planning to geologic and 
natural processes. That is why it is an extremely effective tool for spatial studies. Such flexibility of 
simulation and a big variety of applications were one of the main reasons of enrolling to this course.

### Flooding Simulation

Climate Change is a process that everyday is taking one step further owing to
the human activities. Due to the lack of proper action from our leaders, the
situation is getting closer to the un-return point. 

In other words: once we achieve it, there is no way of going back and save our planet. In these
scenario governments, scientists and society must be ready for the consequences of climate change. 

One of these scenarios is flood as a result of heavy rains in a small amount of period. This type of events are becoming more
common, impacting not only a city infrastructure but also its residents.

Campos dos Goytacazes, a city located in the northwestern part of Rio de Janeiro State, Brazil, is one of these cities that
often suffer from floodings. Placed in the riverbanks of Paraíba do Sul river, Campos plays a major role in the regional economy - that every once in a while is affected by heavy summer storms, that lead to the river floodings (**Citation?**).

Having this brief overview in mind, it is possible to rise the following question: **how much of Campos dos Goytacazes is
affected by flooding event?**

______

## 2. Objectives  <a name="objectives"></a>

For this project, the main objective is to see which areas of Campos is flooded. For that, GAML programming language was used. 

Having a flooding simulation helps several organizations to better plan the city and avoid risky areas. Also, it will assist in case of forecasting extreme events, allowing public power to send early warnings.

_______

## 3. Methodology  <a name="methodology"></a>

The development of this project had 3 main phases: **data collection and pre-processing**, **building the simulation** and finally the **validations**. Let's dig deeper in each of these steps.

______

### Data Collection & Pre-processing

- Urban data: the street network was downloaded from OpenStreetMap using the QGIS plug-in QuickOSM.

- River Data: there are two main type of data related to the river:
    
    - River polygon: the river polygon was generated from a CBERS4A image segmentation. After downloading it from Instituto de Pesquisa Espaciais (INPE), the image was composited and then segmented. All segments that were within the river area and had similar values were filtered, leading to a river polygon.

    - River Height Measures: in Brazil, the Brazilian National Water Agency (Agência Nacional de Águas - ANA) is responsible for measuring rivers' flow and height. Throught HydroBR API, a Python library API, it was possible to select and filter all information for Campos dos Goytacazes. With this resource, it was possible to establish the mean height for Paraíba do Sul river in the study area, which was 6.8m at the `CAMPOS - PONTE MUNICIPAL` fluviometric station from 1922 to 2019. Such information is important because will help understand how much water the area can support, and how long it will take to go above the flooding height, which is 10.4m, according to the last events measured by techinal teams from Campos do Goytacazes City Hall.

- Digital Elevation Model (DEM): the DEM has a 30m pixel resolution. It was downloaded from TOPODATA, an INPE's plataform for surface models. Using QGIS, it was necessary to perform an altitude subtraction process. From all cells within the river polygon, a subtraction of -3 was perfomed in order to make the river depth more representative. With this process, would then be possible to match the river's overflow quota, making the simulation more realistic.  

______

### Building Simulation

To build the flood simulation, was used the main structure of Gaudou (n.d) code avaiable in the Gama Plataform. 

The code has a model definition section (model camposfloodingmodel) and a global section that contains variables, functions and reflexes. The code uses a DEM file, a river shape file and a roads geojson file as input to define the environment, shape of the environment and roads.

The global section contains variables such as ``diffusion_rate``, `drain_cells`, ``source_cells``, and ``input_water``. It also contains functions like init_cells to initialize the altitude of cells, init_water to initialize the height of water in the cells, and flow to simulate the flow of water from one cell to another.

There are several reflexes that perform various functions. The ``add_water_input`` reflex adds water to the source cells, the ``adding_input_water`` reflex adds water to the source cells, the flowing reflex simulates the flow of water based on altitude and obstacles. The ``update_cell_color`` reflex updates the color of cells, and the `draining` reflex drains water from the other cells.

The grid section of the code defines the properties of the cells in the grid and contains an action flow to simulate the flow of water.

Each cell that was flooded receives a value of `1`. After this value assingment, a raster is exported, allowing the comparison with other researches developed in the regions.

____

### Validation


For data validation, it was possible to use the following research projects:

- Mean values of maximum and minimum water flow from 1960 to 2018 from Barbossa et al. (2018) for Campo dos Goytaguazes city area.

- MapBiomas Água (Souza et al., 2020) is a plataform that allows you to analyze water data from 1985 until 2022, showing which locations had gain and loss of water, besides seasonal transitions. 

- Based on the Pekel et al. (2016), the Surface water occurrence probability allows you to check the proability of water occurence near-by the river banks.

The data from Barbossa et al. (2018) and Pekel et al. (2016) are also avaible at Tomislav et al. (2019) platafom called OpenLandMap.

The idea was to compare the simulation output cells to the data provided in the previous works and check how accurate the simulation was.
______

## 4. Results  <a name="results"></a>

______

## 5. Discussion  <a name="discussion"></a>

_____

## 6. Conclusions  <a name="conclusions"></a>

_____

## 7. References  <a name="references"></a>


Barbarossa, V., Huijbregts, M. A., Beusen, A. H., Beck, H. E., King, H., & Schipper, A. M. (2018).
FLO1K, global maps of mean, maximum and minimum annual streamflow at 1 km resolution from 1960 through 2015. Scientific data, 5, 180052. https://doi.org/10.1038/sdata.2018.52

Gaudou, B. (n.d).  Water flow in a river represented by a set of cells, depending on the elevation. Gama Plataform.

OpenStreetMap contributors. (2015). Campo dos Goytacazes street network [Data file]. Retrieved from https://planet.openstreetmap.org

Taillandier, P., Gaudou, P. Grignard, A. Huynh, Q.N., Marilleau, N., Caillou, P., Philippon, D., Drogoul, A. (2018) Building, Composing and Experimenting Complex Spatial Models with the GAMA Platform. GeoInformatica, Dec. 2018. https://doi.org/10.1007/s10707-018-00339-6.

Pekel, J. F., Cottam, A., Gorelick, N., & Belward, A. S. (2016). High-resolution mapping of global surface water and its long-term changes. Nature, 540(7633), 418. http://dx.doi.org/10.1038/nature20584

QGIS.org (2022). QGIS Geographic Information System. QGIS Association. http://www.qgis.org

Souza et al. (2020) - Reconstructing Three Decades of Land Use and Land Cover Changes in Brazilian Biomes with Landsat Archive and Earth Engine - Remote Sensing, Volume 12, Issue 17, 10.3390/rs12172735

Tomislav, H., Collins, T. N., Wheeler, I., & MacMillan, R. A. (2019). Everybody has a right to know what’s happening with the planet: towards a global commons. Medium (Towards Data Science), http://doi.org/10.5281/zenodo.2611127
_____
