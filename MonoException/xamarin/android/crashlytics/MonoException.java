package xamarin.android.crashlytics;

public class MonoException extends Exception{
    private final String message;
    private StackTraceElement[] stack;

    public MonoException(String message, StackTraceElement[] stack){
        this.message = message;
        this.stack = stack;
    }

    public MonoException(String message, StackTraceElement[] stack, Throwable cause){
	super(cause);
        this.message = message;
        this.stack = stack;
    }

    @Override
    public StackTraceElement[] getStackTrace() {
        return stack;
    }

    @Override
    public String getMessage() {
        return this.message;
    }
}