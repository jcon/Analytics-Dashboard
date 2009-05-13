package net.newfoo.logs;
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

import java.awt.event.ActionEvent;
import java.lang.Object;
import javafx.animation.transition.FadeTransition;
import javafx.ext.swing.SwingButton;
import javafx.ext.swing.SwingComponent;
import javafx.ext.swing.SwingLabel;
import javafx.ext.swing.SwingTextField;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.Scene;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.scene.text.TextAlignment;
import javafx.stage.Stage;
import javax.swing.AbstractAction;
import javax.swing.JPasswordField;
import net.newfoo.logs.analytics.client.Site;
import net.newfoo.logs.LoginForm;
import net.newfoo.logs.LoginForm.RequestFocus;
import net.newfoo.logs.SiteChooser;
import org.jfxtras.scene.layout.MigLayout;
import org.jfxtras.scene.layout.MigNode;
import org.jfxtras.stage.JFXDialog;

class RequestFocus extends AbstractAction {
    var node: SwingComponent;
    
    function actionPerformed(event: ActionEvent) {
        node.requestFocus();
    }
}

public class LoginForm extends CustomNode {
    public-init var action: function(username: String, password: String);
    public-init var fake: function(username: String, password: String);
    public var height: Number = 200;
    public var width: Number = 300;
    public var errorMessage: String;

    var username: SwingTextField = SwingTextField {
        action: function() {
            password.requestFocus();
        }
    };
    var password = new JPasswordField() on replace {
        password.setAction(RequestFocus {
            node: loginButton
        });
    }

    var loginButton = SwingButton {
        text: "Login"
        action: function() {
            if (action != null) {
                action(username.text, new String(password.getPassword()));
            }
        }
    };

    var fakeButton = SwingButton {
        text: "Fake Login"
        action: function() {
            fake(username.text, new String(password.getPassword()));
        }
    };

    var dialog: JFXDialog;

    override function requestFocus() {
        username.requestFocus();
    }


    public override function create(): Node {
        return Group {
            content: [
/*                Rectangle {
                    width: bind width
                    height: bind height
                    fill: LinearGradient {
                        endX: 0.0
                        stops: [
                            Stop {
                                offset: 0.0
                                color: Color.rgb(0x22, 0x37, 0x4c, 1.0)
                            },
                            Stop {
                                offset: 0.5
                                color: Color.rgb(0x22, 0x37, 0x4c, 0.74590164)
                            },
                            Stop {
                                offset: 1.0
                                color: Color.rgb(0x22, 0x37, 0x4c, 1.0)
                            }
                          ]
                    }
                }, */
                MigLayout {
                    //              fitParent: true
                    width: bind width
                    height: bind height
                    layout: "fill, wrap"
                    rows: "push[]8px[][][]4px[]push"
                    columns: "[][]"

                    migContent: [
                        MigNode {
                            node: Text {
                                textAlignment: TextAlignment.LEFT
                                content: "Analytics Login"
                                fill: Color.WHITE
                                font: Font.font("Georgia", FontWeight.BOLD, 24)
                            }
                            constraints: "span"
                        },
                        MigNode {
                            node: SwingLabel {
                                foreground: Color.RED
                                text: bind errorMessage
                                visible: bind (errorMessage != null and errorMessage.length() > 0)
                                font: Font.font("Georgia", FontWeight.BOLD, 20)
                            }
                            constraints: "span"
                        },
                        MigNode {
                            node: SwingLabel {
                                foreground: Color.WHITE
                                text: "Email"
                            }
                            constraints: "ax right"
                        },
                        MigNode {
                            node: username
                            constraints: "growx"
                        },
                        MigNode {
                            node: SwingLabel {
                                foreground: Color.WHITE
                                text: "Password"
                            }
                            constraints: "ax right"
                        },
                        MigNode {
                            node: SwingComponent.wrap(password)
                            constraints: "growx"
                        },
                        MigNode {
                            node: loginButton
                            constraints: "ax right"
                        },
                        MigNode {
                            node: fakeButton
                            constraints: "ax left"
                        },
                    ]
                }
            ]
        };
    }
}

public function run() {
    var siteChooser: SiteChooser = SiteChooser {
        visible: false
        sites: [
            new Site("test1", "12345"),
            new Site("test2", "45677"),
            new Site("test3", "89102")
        ]
        action: function(name: String, id: String) {
            println("{name} with id {id} chosen");
        }
    };

    var loginForm: LoginForm = LoginForm {
        height: 300
        width: 400
        action: function(username, password) {
            println("{username}/{password} submitted");
            var duration = 400ms;
            siteChooser.visible = true;
            var trans1 = FadeTransition {
                fromValue: 0
                toValue: 1
                node: siteChooser
                duration: duration
            }
            var trans2 = FadeTransition {
                fromValue: 1
                toValue: 0
                node: loginForm
                duration: duration
            }
            trans1.play();
            trans2.play();
        }
    };

    Stage {
        title: "Mig Grow Test"
        scene: Scene {
            width: 400
            height: 300
            fill: LinearGradient {
              endX: 0.0
              stops: [
                Stop { offset: 0.0, color: Color.SLATEGRAY },
                Stop { offset: 1.0, color: Color.DARKSLATEGRAY },
              ]
            }

            content: Group {
                content: [
                    siteChooser,
                    loginForm
                ]
            }

            /*
                SwingButton {
                    text: "Login"
                    action: function() {
                       var dialog: JFXDialog = JFXDialog {
                            height: 200
                            width: 300
                            modal: true
                            scene: Scene {
                                fill: LinearGradient {
                                    endX: 0.0
                                    stops: [
                                        Stop {
                                            offset: 0.0
                                            color: Color.rgb(0x62, 0x5b, 0x2e, 1.0)
                                        },
                                        Stop {
                                            offset: 1.0
                                            color: Color.rgb(0x86, 0x82, 0x66, 1.0)
                                        },
                                      ]
                                }
                                content: LoginForm {
                                    action: function(username, password) {
                                        println("{username}/{password} submitted");
                                        dialog.close();
                                    }
                                }
                            }
                        } 
                        var dialog: LoginForm = LoginForm {
                            action: function(username, password) {
                                println("{username}/{password} submitted");
                                dialog.close();
                            }
                        }
                        dialog.show();

                    }
                }
                */
        }
    }
}
