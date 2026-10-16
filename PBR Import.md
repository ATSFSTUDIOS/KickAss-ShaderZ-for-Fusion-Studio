# PBR IMPORT

The KickAss ShaderZ toolset ships with a custom "File > Import > PBR Textures..." menu entry.

The "Substance PBR Import" script reads the image from the selected Loader node and expands it to import the full set of Substance painter style "PBR metal roughness" texture maps.

In a practical sense, the process of running this script works in a very similar way to the "hos_SplitEXRUltra" script in that it loads in multiple images based upon a single selected Loader node in the comp.

## Usage:

Step 1. Select a Loader node in the Flow view.

Step 2. Right-click in the flow view and from the contextual menu select the "Script < KickAss ShaderZ < Substance PBR Import" menu item to launch the script.

Step 3. Customize the settings in the dialog, then click the &quot;Create PBR Material&quot; button.

## GUI Controls:

### PBR Surface Material
The "PBR Surface Material" ComboBox allows you to choose either a "Cook Torrance/Reflect", or a "CustomShader3D (Alpha)" based material workflow.

Note: You need to have the 3rd party "CustomShader3D" plugin installed in Fusion Studio v9 for Windows in order to use this option.

### Add Environment Map
The "Add Environment Map" checkbox allows you to have an HDRI panoramic image added to the node graph automatically.

### Add Shader Ball
The "Add Shader Ball" checkbox allows you to have a polygon mesh added to the node graph automatically for use as preview geometry for your surface materials.

### Add Note
The "Add Note" checkbox inserts a note node into the composite which summarizes the texture maps and settings used when the PBR materials were imported.

### Reset to Defaults
The "Reset to Defaults" checkbox reverts the settings in the dialog back to their initial factor default values.

### ? / Help
The "?" help button shows the built-in help documentation (which you are currently viewing now).

### Create PBR Material

The "Create PBR Material" button will process the current Loader node selection in the flow view to generate a full set of imported PBR maps connected to a Fusion surface material.

### Image Channels:

A Substance "PBR Metal Rough" export workflow is expected by this script. That means you will have a set of texture maps with the following PBR map channels:

- BaseColor
- Roughness
- Normal
- Metallic
- Height
- Emissive

These maps will be named with a filename formatted like:

`image_<map>.ext`

# Substance Material Export Settings

In Substance Painter select the "File >Export Textures..." menu item to prepare your final baked and flattened texture maps.

In the "Export document..." dialog set the export location using the button at the top of the dialog. Then set the "Config" attribute to use the "PBR MetalRough" option to generate the correct texture maps.

Finally, click the "Export" button to save out the textures.