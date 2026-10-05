# 🧪 Rep-It-Up-in-Fiji
## A fast, customizable ImageJ/Fiji macro for representative microscopy images

**Less repetitive clicking. More time for science.** 🚀

This repository contains a custom ImageJ Macro Language (`.ijm`) script intended to speed up the creation of representative images from multichannel microscopy TIFF files.

The macro was developed in the context of microscopy and image-analysis workflows at the Autophagy Laboratory, JNCASR, Bengaluru, India. The original script was written on 30 November 2023.

---

## 📦 What is included?

```text
rep-it-up-in-fiji/
├── RepMakingInFijiImageJ.ijm   # The ImageJ/Fiji macro
├── README.md                   # This guide
└── .gitignore                  # Ignores common temporary files
```

## 🎯 What does the macro do?

For each filename in the input folder that ends in the lowercase extension `.tif`, the current macro attempts to:

1. Open the image using the Bio-Formats importer.
2. Split the image into three channels.
3. Convert the channel images to 8-bit.
4. Create a maximum-intensity Z projection for each channel.
5. Enhance contrast on each projection using a saturation setting of `0.35`.
6. Merge the three projections into a composite image.
7. Add a scale bar to the composite and to each individual channel projection.
8. Save the composite and channel projections as JPEG files.
9. Close image windows before continuing to the next input file.

The macro enables batch mode to reduce GUI updates during processing.

### Workflow at a glance

```text
Input folder
    │
    ▼
Find .tif files
    │
    ▼
Open with Bio-Formats
    │
    ▼
Split into three channels
    │
    ├─────────────┬─────────────┐
    ▼             ▼             ▼
  Channel 1     Channel 2     Channel 3
    │             │             │
    ▼             ▼             ▼
  Convert       Convert       Convert
  to 8-bit      to 8-bit      to 8-bit
    │             │             │
    ▼             ▼             ▼
 Maximum       Maximum       Maximum
 Z projection  Z projection  Z projection
    │             │             │
    └─────────────┼─────────────┘
                  ▼
             Merge channels
                  │
                  ▼
             Add scale bar
                  │
                  ▼
             Save JPEG outputs
```

## 🧰 Requirements

- **Fiji** (recommended): https://fiji.sc/
- **Bio-Formats importer** available in Fiji.
- Microscopy images in a format supported by the installed Bio-Formats version, saved with the `.tif` extension for the current file filter.
- Read/write access to the input and output directories.

If Bio-Formats is unavailable, update Fiji using **Help → Update Fiji**, then restart Fiji if needed.

## 🚀 Quick start

1. Download or clone this repository.
2. Open Fiji.
3. Choose **Plugins → Macros → Run…**
4. Select `RepMakingInFijiImageJ.ijm`.
5. Before running on valuable data, edit the input and output folder paths described below.
6. Test on a small folder containing a few representative files.
7. Inspect every output and verify channel order, contrast, calibration, and scale-bar meaning.

You can edit the `.ijm` file with Fiji's macro editor or any plain-text editor. Keep a backup before making changes.

---

## 🛠️ First customization: input and output folders

Near the beginning of the macro, find:

```javascript
inputDir = "D:/n3_27x_nmjs_deconwolffed/CombinedChannels/";
outputDir = "C:/Users/rd12d/Downloads/AutomatedRepMakingNMJs/";
```

Change these paths to match your computer and experiment. For example:

```javascript
inputDir = "D:/MyExperiment/RawImages/";
outputDir = "D:/MyExperiment/RepresentativeImages/";
```

**Input directory:** the folder containing the images to process.

**Output directory:** the folder where generated JPEGs will be saved. Create this folder before running the current macro; the macro does not explicitly create it.

### Windows path tip

Forward slashes are convenient in ImageJ macro strings:

```javascript
inputDir = "C:/Users/YourName/Desktop/MyImages/";
```

Keep the trailing slash so that concatenating a filename produces a complete path.

---

## 🖼️ Which files are selected?

The current condition is:

```javascript
if (endsWith(list[i], ".tif")) {
```

This matches filenames ending in lowercase `.tif`. It does not currently match `.tiff`, `.TIF`, `.czi`, `.nd2`, or other extensions through that condition.

To include `.tiff` files, you could change the condition to:

```javascript
if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
```

For mixed-case extensions, implement and test a case-insensitive extension check appropriate to your ImageJ macro version.

**Note:** Bio-Formats can support many microscopy formats, but a file must still pass the macro's filename filter before it will be opened.

---

## 🌈 Channel assumptions

The current macro expects three split-channel windows and refers to them as:

```javascript
C1_Name = "C1-" + subsetTitle;
C2_Name = "C2-" + subsetTitle;
C3_Name = "C3-" + subsetTitle;
```

It subsequently renames these windows `RedChannel`, `GreenChannel`, and `BlueChannel`.

These labels are assumptions made by the script; they do not independently verify the fluorophore identity or acquisition metadata. Confirm the channel order for your own microscope and dataset. Images with a different number of channels may require code changes.

---

## 🧬 What is a maximum-intensity Z projection?

The macro runs:

```javascript
run("Z Project...", "projection=[Max Intensity]");
```

For each pixel position `(x,y)`, a maximum-intensity projection selects the largest pixel value across the included Z planes:

\[
I_{\mathrm{MIP}}(x,y)=\max_z I(x,y,z)
\]

This converts a Z-stack into a 2D image. It can make fluorescent structures at different depths visible together, but it removes depth information and can make overlapping structures appear superimposed.

The current script does not explicitly run the **Make Subset** command: the relevant lines are commented out. Therefore, do not assume that it automatically selects a particular Z range. Confirm the intended stack and projection range before using the output.

---

## 🎨 Contrast enhancement and 8-bit conversion

The macro converts each split channel to 8-bit and applies:

```javascript
resetMinAndMax;
run("Enhance Contrast", "saturated=0.35");
```

The saturation parameter is a visualization setting. Changing it can change the appearance of the image. Contrast enhancement and conversion to 8-bit can also affect how pixel values are represented.

For scientific comparisons:

- Apply a documented, consistent visualization policy across groups.
- Keep original raw data unchanged.
- Do not infer quantitative fluorescence differences from contrast-adjusted JPEGs.
- Validate the display settings against the original data before figure preparation.

This macro is primarily for representative-image generation, not for preserving quantitative intensity values.

---

## 📏 Scale bar: check calibration!

The current command is:

```javascript
run("Scale Bar...", "width=20 height=20 thickness=10 font=40 bold overlay label");
```

The intended width is `20` in the image's calibrated spatial units, if the image is correctly calibrated. **Do not automatically assume that this means 20 µm.**

Before using a scale bar in a figure, inspect the image calibration in Fiji using **Image → Properties** and check pixel width, pixel height, depth, and unit. Confirm that the resulting bar has the correct physical length.

The `overlay` option may preserve the scale bar as an overlay rather than permanently changing pixel data, depending on the command and image state. Inspect the exported JPEG to confirm the bar appears as intended.

---

## 💾 Output filenames

For an input file named `Sample01.tif`, the current naming scheme attempts to produce:

```text
Sample01.tif_MergedRep.jpg
Sample01.tif_MAX_RedChannel.jpg
Sample01.tif_MAX_GreenChannel.jpg
Sample01.tif_MAX_BlueChannel.jpg
```

The merged output is generated from the maximum-intensity projections, not from the original unprojected Z-stack.

JPEG is a lossy format. For scientific archiving or further quantitative analysis, retain the original microscopy files and consider a suitable lossless export workflow when needed.

---

## ⚡ Why use batch mode?

The macro uses:

```javascript
setBatchMode(true);
```

Batch mode reduces display updates during processing and can improve throughput for repetitive tasks. At the end, the macro calls:

```javascript
setBatchMode(false);
```

Processing time depends on image size, number of Z planes, channel count, file format, disk speed, memory, and Fiji/Bio-Formats configuration. “Fast” is a goal, not a guaranteed processing time.

---

## 🧹 Cleanup between images

The current macro calls:

```javascript
roiManager("reset");
run("Close All");
```

at the end of each loop iteration. This clears the ROI Manager and closes open image windows, helping prevent window accumulation. If you add new outputs, dialogs, or windows, check that they are saved before cleanup.

---

## 🧪 Commented-out sections

Several parts of the macro are currently commented out using `//`. They include examples of:

- ROI-based background subtraction
- Manual ROI selection
- Thresholding
- Analyze Particles
- Results and summary CSV exports
- Additional interactive steps

Commented code does not run. To enable a section, first understand what it does, make a backup, and test on copies of a few images. Uncomment only the relevant lines; some sections may depend on variables, ROIs, or windows that are not created by the active workflow.

### Background subtraction caution

Background subtraction is not universally appropriate. Select a method based on the acquisition, sample, and scientific question. Do not enable the older ROI-based example without checking its assumptions and verifying the resulting images.

---

## 🐛 Troubleshooting

### Nothing happens / no images are processed

- Check that `inputDir` points to the correct folder.
- Confirm that filenames end in lowercase `.tif`.
- Confirm that the input folder contains files directly: `getFileList(inputDir)` is used, and the current code does not explicitly recurse through subfolders.
- Check the Fiji Log window for errors.

### Output files are missing

- Confirm that `outputDir` exists and is writable.
- Check available disk space.
- Inspect the Log window for failed save commands.
- Test with one or two files before running a large batch.

### A channel window cannot be found

- Verify that the source image actually contains three channels.
- Check the Bio-Formats import settings and channel order.
- Inspect the window titles produced by your Fiji version.
- The current script uses specific window names, so changes in import behavior may require adjustments.

### The scale bar is incorrect

- Check **Image → Properties** and spatial calibration.
- Verify the intended unit and width.
- Inspect the saved JPEG rather than assuming the overlay exported correctly.

### The macro stops partway through

- Test one input image first.
- Check the Log window and macro error message.
- Verify sufficient memory and disk space.
- Keep raw files untouched and test modifications on copies.

---

## 🔬 Good scientific practice

Before using outputs in a presentation, thesis, or publication:

- Preserve the original raw data.
- Apply consistent processing policies across experimental groups.
- Verify channel identity and order.
- Check scale-bar calibration.
- Record projection and contrast settings.
- Inspect each output for artifacts, clipping, unexpected colors, and missing structures.
- Follow your institution's and target journal's image-processing policies.

**Representative images are illustrative.** Quantitative claims should be supported by an appropriate analysis of the original data using a validated workflow.

---

## 🧑‍💻 Contributing and adapting

Fork this repository or make a local copy before modifying the macro. Useful future additions could include:

- User dialogs for input/output folder selection
- Recursive subfolder processing
- Case-insensitive `.tif` and `.tiff` detection
- Explicit channel and Z-range validation
- Metadata-aware scale-bar checks
- Configurable contrast and output formats
- Processing logs and error summaries
- Optional lossless output formats

If you make a change, test it on a small set of representative files and document the new behavior.

## 📜 Provenance

The original macro for representative image-making was derived from an object-based, semi-automated ImageJ colocalization macro. It records a completion date of **30 November 2023**,  contributors from the Autophagy Laboratory, JNCASR, and a special acknowledgment to Jishnu Goswami.

Please retain appropriate attribution when redistributing or adapting the script, and clarify any additional changes you make.

## ❤️ The golden rule

**Keep raw data sacred. Make visualization reproducible. Check the scale bar.**

## 🔗 Repository

https://github.com/RDwithMATLAB/rep-it-up-in-fiji

🧪 Rep it up. Make science. Move on.
