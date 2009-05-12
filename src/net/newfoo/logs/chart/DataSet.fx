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
import javafx.geometry.Point2D;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.input.MouseEvent;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Circle;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.Path;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.scene.text.TextOrigin;
import javafx.scene.transform.Translate;

public class DataSet extends CustomNode {

    public var values: Point2D[];
    public var labels: String[];
    public-init var fill: Paint;
    public-init var pointFill: Paint;

    public var yIncrement: Number;

    public var xIncrement: Number; 

    public var padding: Number = 5;

    var nodes: Node[];

    public override function create(): Node {
        var group = Group {
            content: bind [
                getGraph( xIncrement, yIncrement )
            ]
        };
        return group;
    }

    public function labelFor(value): String {
        return labels[value as Integer];
//        return String.valueOf(value);
    }


    function getGraph( xIncrement: Number, yIncrement: Number) : Node[] {
        println("getGraph({xIncrement}, {yIncrement})");

        delete nodes;
//        var nodes: Node[];
        var lastGraphPoint: Point2D = null;
        var parentBounds = parent.boundsInLocal;
        println("{parentBounds.minX},{parentBounds.minY} ; {parentBounds.height}x{parentBounds.width}");
        var minX = parentBounds.minX + padding + ((values[0].x - 1) * xIncrement);
        var minY = (parentBounds.minY + (parentBounds.height - values[0].y * yIncrement));
        var maxX = parentBounds.minX + padding + ((values[values.size() - 1].x - 1) * xIncrement);
        var path = Path {
            elements: [
                MoveTo {
                    x: minX
                    y: minY
                },
                for (i in [1..values.size() - 1]) {
                    LineTo {
                        x: parentBounds.minX + padding + ((values[i].x - 1) * xIncrement)
                        y: (parentBounds.minY + (parentBounds.height - values[i].y * yIncrement))
                    }
                },
                LineTo {
                    x: maxX
                    y: parentBounds.maxY
                },
                LineTo {
                    x: minX
                    y: parentBounds.maxY
                },
                LineTo {
                    x: minX
                    y: minY
                } 
            ]
            stroke: null
            fill: fill,
        }
        insert path into nodes;
        for (i in [1..values.size() - 1]) {
            var c = Circle {
                centerX: parentBounds.minX + padding + ((values[i].x - 1) * xIncrement)
                centerY: (parentBounds.minY + (parentBounds.height - values[i].y * yIncrement))
                radius: 4
                fill: pointFill
            };
            var t = Text {
                x: 0
                y: 0
                content: "{labelFor(i)}\n{values[i].y as Integer}"
                textAlignment: TextAlignment.CENTER
                textOrigin: TextOrigin.TOP
                fill: Color.WHITE
            };
            var r = Rectangle {
                x: 0
                y: 0
                width: bind t.boundsInLocal.width + 10
                height: bind t.boundsInLocal.height + 4
                fill: Color.rgb(0x62, 0x5b, 0x2e, 1.0)
                stroke: Color.WHITE
                strokeWidth: 2
            };
            var b = Group {
                visible: false
                transforms: Translate {
                    x: bind parentBounds.minX + padding + ((values[i].x - 1) * xIncrement) - t.boundsInLocal.width / 2
                    y: bind (parentBounds.minY + (parentBounds.height - values[i].y * yIncrement)) - t.boundsInLocal.height - padding
                }
                content: [
                    r,
                    t
                ]
            };
            t.transforms = Translate {
                x: bind (r.boundsInLocal.width - t.boundsInLocal.width) / 2
                y: bind (r.boundsInLocal.height - t.boundsInLocal.height) / 2
            }
            var enter = function(e:MouseEvent): Void {
                b.visible = true;
            }
            var exit = function(e:MouseEvent): Void {
                b.visible = false;
            }
            c.onMouseEntered = enter;
            c.onMouseExited = exit;
            b.onMouseExited = exit;
            insert c into nodes;
            insert b into nodes;
        }
        return nodes;
    }
}