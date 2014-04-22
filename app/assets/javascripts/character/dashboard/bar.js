/*
    http://trifacta.github.io/vega/
*/
window.Character.Dashboard.Bar = {
  "width": 500,
  "height": 240,
  "padding": {"top": 40, "left": 50, "bottom": 40, "right": 10},
  "data": [
    {
      "name": "table",
      "values": [
        {"x": 1,  "y": 28}, {"x": 2,  "y": 55},
        {"x": 3,  "y": 43}, {"x": 4,  "y": 91},
        {"x": 5,  "y": 81}, {"x": 6,  "y": 53},
        {"x": 7,  "y": 19}, {"x": 8,  "y": 87},
        {"x": 9,  "y": 52}, {"x": 10, "y": 48},
        {"x": 11, "y": 24}, {"x": 12, "y": 49},
        {"x": 13, "y": 87}, {"x": 14, "y": 66},
        {"x": 15, "y": 17}, {"x": 16, "y": 27},
        {"x": 17, "y": 68}, {"x": 18, "y": 16},
        {"x": 19, "y": 49}, {"x": 20, "y": 15}
      ]
    }
  ],
  "scales": [
    {
      "name": "x",
      "type": "ordinal",
      "range": "width",
      "domain": {"data": "table", "field": "data.x"}
    },
    {
      "name": "y",
      "range": "height",
      "nice": true,
      "domain": {"data": "table", "field": "data.y"}
    }
  ],
  "axes": [
    { "type": "x", "scale": "x",
      "properties": {
        "ticks":      { "stroke":      { "value": "#d1d6e0" } },
        "majorTicks": { "strokeWidth": { "value": 1 } },
        "labels": {
          "fill": { "value": "#a9b1b5" },
          "angle": {"value": 50},
          "align": {"value": "left"},
          "baseline": {"value": "middle"},
          "dx": {"value": 3 }
        },
        "axis": { "stroke": { "value": "#d1d6e0" }, "strokeWidth": { "value": 1 } }
      }
    },
    { "type": "y", "scale": "y", "ticks": 5,
      "properties": {
        "ticks":      { "stroke":      { "value": "#d1d6e0" } },
        "majorTicks": { "strokeWidth": { "value": 1 } },
        "labels": { "fill":   { "value": "#a9b1b5" } },
        "axis":   { "stroke": { "value": "#d1d6e0" }, "strokeWidth": { "value": 1 } }
      }
    }
  ],
  "marks": [
    {
      "type": "rect",
      "from": {"data": "table"},
      "properties": {
        "enter": {
          "x":     {"scale": "x", "field": "data.x"},
          "width": {"scale": "x", "band": true, "offset": -1},
          "y":     {"scale": "y", "field": "data.y"},
          "y2":    {"scale": "y", "value": 0},
          "text":  {"field": "data.y"}
        },
        "update": {
          "fill": {"value": "#78e7c8"},
          "fillOpacity": {"value": 0.5}
        }//,
        // "hover": {
        //   "fillOpacity": {"value": 1}
        // }
      }
    },

    {
      "type": "text",
      "from": {"data": "table"},
      "properties": {
        "enter": {
          "x":        {"scale": "x", "field": "data.x"},
          "y":        {"scale": "y", "field": "data.y"},
          "baseline": {"value": "bottom"},
          "align":    {"value": "left"},
          "text":     {"field": "data.y"},
          "fontSize": {"value": 11}
        },
        "update": {
          "fill": {"value": "#a9b1b5"}
        }//,
        // "hover": {
        //   "fillOpacity": {"value": 1}
        // }
      }
    }
  ]
};