import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import streamlit as st

# --- Page Configuration ---
st.set_page_config(
    page_title="A Quick Question...",
    page_icon="✨",
    layout="centered",
)

# --- Custom Styling ---
st.markdown(
    """
    <style>
    .main-card {
        padding: 2rem;
        border-radius: 14px;
        background: #fafafa;
        border: 1px solid #eaeaea;
        margin-bottom: 1.5rem;
    }
    .status-box {
        padding: 1.25rem;
        border-radius: 10px;
        margin-top: 1.25rem;
        line-height: 1.6;
    }
    .yes-box {
        background-color: #f0fdf4;
        border: 1px solid #bbf7d0;
        color: #166534;
    }
    .maybe-box {
        background-color: #fffbeb;
        border: 1px solid #fef3c7;
        color: #92400e;
    }
    .no-box {
        background-color: #fef2f2;
        border: 1px solid #fecaca;
        color: #991b1b;
    }
    </style>
""",
    unsafe_allow_html=True,
)


# --- Helper: Email Dispatcher ---
def send_notification_email(response_choice, extra_feedback, secret_code):
    """Sends an automated email notification using SMTP settings stored in st.secrets."""
    try:
        smtp_server = st.secrets["SMTP_SERVER"]
        smtp_port = int(st.secrets["SMTP_PORT"])
        sender_email = st.secrets["SENDER_EMAIL"]
        sender_password = st.secrets["SENDER_PASSWORD"]
        recipient_email = st.secrets["RECIPIENT_EMAIL"]

        msg = MIMEMultipart()
        msg["From"] = sender_email
        msg["To"] = recipient_email
        msg["Subject"] = f"New Response Received: {response_choice}"

        body = f"""
        Someone just submitted your response form!

        • Selection: {response_choice}
        • Feedback / Reason: {extra_feedback or 'None provided'}
        • Verification / Secret Code: {secret_code or 'None entered'}
        """
        msg.attach(MIMEText(body, "plain"))

        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, recipient_email, msg.as_string())
        return True, "Response captured and sent successfully!"
    except Exception as e:
        return False, f"Failed to send email: {str(e)}"


# --- App Header & Primary Question ---
st.title("Hey there ✨")
st.write(
    "I wanted to ask you something directly, without any games or pressure."
)

st.markdown("### Would it be alright if I get to know you a bit better?")

# --- Slider Component ---
# Equidistant discrete options using select_slider
options = ["No", "Maybe", "Yes"]
selection = st.select_slider(
    label="Slide to your answer:",
    options=options,
    value="Maybe",
    help="Slide across to select your response.",
)

# Store reason if "No" is selected
no_reason_selected = None

# --- Dynamic Dynamic Response Display ---
if selection == "Yes":
    st.markdown(
        """
        <div class="status-box yes-box">
            <strong>Brilliant choice.</strong><br>
            Low pressure, great conversations, and zero expectations beyond discovering if we vibe. 
            I appreciate someone who is decisive and open to new connections.
        </div>
        """,
        unsafe_allow_html=True,
    )

elif selection == "Maybe":
    st.markdown(
        """
        <div class="status-box maybe-box">
            <strong>Completely fair.</strong><br>
            Healthy skepticism is underrated. We don't have to jump into lengthy calls or awkward dinners; 
            think of it as a casual low-stakes chat—if the conversation flows naturally, great. If not, no harm done at all.
        </div>
        """,
        unsafe_allow_html=True,
    )

elif selection == "No":
    st.markdown(
        """
        <div class="status-box no-box">
            <strong>Understood and completely respected.</strong><br>
            Honesty is always appreciated. If you don't mind sharing, which of these resonates most?
        </div>
        """,
        unsafe_allow_html=True,
    )

    no_reason_selected = st.radio(
        "Help me understand (optional):",
        options=[
            "Currently seeing someone / emotionally unavailable",
            "Not looking to connect with anyone new right now",
            "Prefer to keep things strictly professional/distant",
            "Just not feeling the vibe",
        ],
        index=0,
    )

st.divider()

# --- Code Acceptance & Submission Dialog ---


@st.dialog("Complete Submission")
def submission_modal(selected_value, feedback):
    st.write("Enter your verification or passkey code below to submit:")
    entered_code = st.text_input(
        "Passcode / Secret Code",
        type="password",
        placeholder="e.g., COFFEE2026",
    )

    if st.button("Confirm & Send", type="primary", use_container_width=True):
        if not entered_code.strip():
            st.error("Please enter a valid code before submitting.")
        else:
            with st.spinner("Submitting your answer..."):
                success, msg = send_notification_email(
                    response_choice=selected_value,
                    extra_feedback=feedback,
                    secret_code=entered_code,
                )
            if success:
                st.success("Your answer has been sent! Thank you for sharing.")
            else:
                st.error(msg)


if st.button(
    "Submit My Response 📩", type="primary", use_container_width=False
):
    feedback_payload = (
        no_reason_selected if selection == "No" else "Standard answer path"
    )
    submission_modal(selection, feedback_payload)
