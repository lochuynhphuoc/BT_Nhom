package com.group.trainapp.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class ToastUtil {
    public static void setFlash(HttpServletRequest req, String message, String type) {
        HttpSession session = req.getSession();
        session.setAttribute("flashMessage", message);
        session.setAttribute("flashType", type); // success, error, info
    }

    // In JSP, we will read this. Better: remove it after reading.
    // However, JSTL doesn't easily "pope" attributes.
    // We'll trust the JSP to render it into the hidden input and javascript to show
    // it.
    // Ideally, we should remove it from session after rendering.
    // We can do this in a Filter or just rely on overwriting.
}
