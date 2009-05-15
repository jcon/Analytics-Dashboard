package net.newfoo.logs.chart;
/*
 * Copyright (c) 2009 Jim Connell
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import javafx.animation.transition.FadeTransition;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.Transition;
import javafx.geometry.Point2D;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.scene.text.TextOrigin;
import javafx.scene.transform.Rotate;
import net.newfoo.logs.chart.DataSet;
import javafx.animation.Interpolator;

public class Chart {

    public var title: String;

    public-init var ui: Group on replace {
        if (ui != null) {
            initItems();
        }
    }

    var chart: Group;
    var yAxis: Group;
    var xAxis: Group;
    var titleText: Text;

    var x: Number = bind chart.boundsInLocal.minX;
    var y: Number = bind chart.boundsInLocal.minY;
    var height: Number = bind chart.boundsInLocal.height;
    var width: Number = bind chart.boundsInLocal.width;

    public-init var xLabel: String;
    public-init var yLabel: String;

    public-init var labelFont = Font.font("Arial", FontWeight.BOLD, 14);
    public-init var labelColor = Color.WHITE;


    public var items: DataSet[] on replace {
        initItems();
        updateItems();

        var transitions: Transition[];
        for (item in items) {
            insert FadeTransition {
                fromValue: 0
                toValue: 1
                node: item
                duration: 300ms
                interpolate: Interpolator.EASEIN
            } into transitions;
        }
        var t = ParallelTransition {
            content: transitions
        }
        t.play();
    }


    var maxY: Integer = 0;
    var maxX: Integer = 0;
    var yIncrement;
    var xIncrement;
    var padding = 5;

    var labels: Node;

    init {
        updateItems();
    }

    function initItems() {
        chart = group("chart");
        yAxis = group("chartYAxis");
        xAxis = group("chartXAxis");
        titleText = group("chartTitle").content[0] as Text;
    }

    function group(name: String): Group {
        ui.lookup(name) as Group;
    }


    function updateItems() {
        maxX = 0;
        maxY = 0;
        for (item in items) {
            checkMax(item.values);
        }

        xIncrement = (width - 2 * padding) / (maxX - 1);
        yIncrement = height / (maxY + 1);
        println("xInc={xIncrement} yInc={yIncrement}");
        delete chart.content[2] ;
        for (node in chart.content) {
            if (node instanceof DataSet) {
                delete node from chart.content;
            }
        }
        insert items after chart.content[1];
        for (item in items) {
            item.xIncrement = xIncrement;
            item.yIncrement = yIncrement;
            item.padding = padding;
        }

        delete yAxis.content;

        var yContent = Group {
            content: [
                for (i in [1 .. maxY]) {
                    var visible = (yIncrement > 180 or
                                    i mod ((180 / yIncrement) as Integer) == 0);
                    if (visible) {
                        var line = Line {
                            startX: x + padding
                            startY: y + (height - i * yIncrement)
                            endX: bind x + width
                            endY: y + (height - i * yIncrement)
                            visible: visible
                            stroke: Color.rgb(55, 55, 55)
                            strokeWidth: 3
                            strokeDashArray: [1, 12]
                        };
                        var text: Text = Text {
                            fill: labelColor;
                            font: labelFont
                            translateX: bind -1 * (text.boundsInLocal.width + padding)
                            translateY: bind -1 * text.boundsInLocal.height / 2
                            x: x
                            y: y + (height - i * yIncrement)
                            content: "{i}"
                            textAlignment: TextAlignment.RIGHT
                            textOrigin: TextOrigin.TOP
                            visible: visible
                        };

                        [line, text];
                    } else {
                        [];
                    }

                },
            ]
        };
        insert yContent into yAxis.content;
        yAxis.toFront();
        delete xAxis.content;
        var xContent = Group {
            content:
                for (i in [1 .. maxX - 2]) {
                    var text: Text = Text {
                        fill: labelColor
                        font: labelFont
                        translateX: bind -1 * (text.boundsInLocal.width / 2);
                        x: x + i * xIncrement
                        y: y + height + padding
                        content: "{items[0].labelFor(i)}"
                        textOrigin: TextOrigin.TOP
                        visible: (xIncrement > 40 or (i mod (40 / xIncrement) as Integer) == 0);
                    };
                },
        };
        insert xContent into xAxis.content;
        
        titleText.content = title;
    }


    function checkMax(points: Point2D[]) {
        for (point in points) {
            if (point.y > maxY) {
                maxY = point.y as Integer;
            }
            if (point.x > maxX) {
                maxX = point.x as Integer;
            }
        }
    }



    function create(x, y, height, width): Node {

//        var bounds = ui.boundsInScene;
        var previousPoint;
        def LABEL_PADDING = 5;
        var group = Group {
//            translateX: 50
            content: [
                Group {
                    content: [
                        for (i in [1 .. maxY]) {
                            [
                                Line {
                                    startX: x + padding
                                    startY: y + (height - i * yIncrement)
                                    endX: x + width
                                    endY: y + (height - i * yIncrement)
                                    visible: (yIncrement > 180 or i mod (
                                    (180 / yIncrement) as Integer) == 0)
//                                    stroke: Color.DARKOLIVEGREEN
                                    stroke: Color.rgb(55, 55, 55)
                                    strokeWidth: 3
                                    strokeDashArray: [1, 12]
                                },
                            ]
                        },
                    ]
                },
                for (i in [1 .. maxX]) {
//                    println("tick: {i} is at {x + i * xIncrement} (x={x}, xInc={xIncrement}");
                    Text {
                        x: x + i * xIncrement
                        y: y + height + LABEL_PADDING
                        content: "{i}"
                        textOrigin: TextOrigin.TOP
                    }
                },
                for (i in [1 .. maxY]) {
                    [
                        Text {
                            x: x - LABEL_PADDING * 5
                            y: y + (height - i * yIncrement)
                            content: "{i}"
                            textAlignment: TextAlignment.RIGHT
                            textOrigin: TextOrigin.BASELINE
                            visible: (yIncrement > 180 or i mod (
                            (180 / yIncrement) as Integer) == 0)
                        }
                    ]
                },
                Text {
                    font: Font {
                        name: "Lucida Garde"
                        size: 36
                    }
                    x: x
                    y: y + height + 20
                    content: xLabel
                    textOrigin: TextOrigin.TOP
                },
                Text {
                    font: Font {
                        name: "Lucida Garde"
                        size: 36
                    }
                    x: x - 15 //- LABEL_PADDING * 4
                    y: y + height //+ (height * yIncrement)
                    content: yLabel
                    textOrigin: TextOrigin.TOP
                    transforms: [
                        Rotate {
                            angle: 270
                            pivotX: x - 15 //- LABEL_PADDING * 4
                            pivotY: y + height //+ (height * yIncrement)
                        }
                    ]
                },
            ]
        };
        return group;
    }
}