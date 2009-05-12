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

import javafx.scene.Node;
import net.newfoo.logs.analytics.client.AnalyticsClient;
import net.newfoo.logs.analytics.client.GdataAnalyticsClient;
import net.newfoo.logs.analytics.client.AnalyticsException;
import net.newfoo.logs.analytics.client.Site;
import net.newfoo.logs.LoginForm;
import net.newfoo.logs.SiteChooser;
import javafx.scene.Group;
import net.newfoo.logs.analytics.client.FakeAnalyticsClient;

public class LoginController {
    public-init var afterLogin: function(client: AnalyticsClient, site: String);
    public-read var content: Node;
    var client: AnalyticsClient;
    var sites: Site[];
    var siteChooser: SiteChooser = SiteChooser {
        visible: false
        sites: bind sites
        action: function(name: String, id: String) {
            println("chose {name} with id {id} chosen");
            client.setProfileId(id);
            siteChooser.visible = false;
            afterLogin(client, name);
        }
    };
    var loginForm: LoginForm = LoginForm {
        height: 300
        width: 400
        visible: false
        action: function(username, password) {
            client = GdataAnalyticsClient{ };
            println("logging in with {username}");
            try {
                client.login(username, password);
                if (client.getSites().size() == 1) {
                    var site = client.getSites().get(0);
                    client.setProfileId(site.getProfileId());
                    afterLogin(client, site.getName());
                } else {
                    for (s in client.getSites()) {
                        insert s into sites;
                    }
                    showSiteChooser();
                }
            } catch (ae:AnalyticsException) {
                loginForm.errorMessage = "Invalid Username/Password";
            }
        }
        fake: function(username, password) {
            client = FakeAnalyticsClient{ };
            afterLogin(client, "blahisnewfoo.com");
        }
    };

    init {
        content = Group {
            translateX: bind content.boundsInLocal.minX - (content.parent.boundsInLocal.width - content.boundsInLocal.width) / 2;
            translateY: bind content.boundsInLocal.minY - (content.parent.boundsInLocal.height - content.boundsInLocal.height) / 2;
            content: [
                siteChooser,
                loginForm
            ]
        };
    }

    public function showLogin(): Void {
        println("showLogin()");
        content.visible = true;
        content.opacity = 1;
        loginForm.visible = true;
        loginForm.opacity = 1;
        loginForm.requestFocus();
    }

    public function showSiteChooser() {
        siteChooser.visible = true;
        var trans = SwapTransition {
            inNode: siteChooser
            outNode: loginForm
            duration: 400ms
        }
        trans.play();
    }


}
