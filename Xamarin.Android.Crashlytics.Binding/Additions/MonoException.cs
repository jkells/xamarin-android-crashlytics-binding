using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using Java.Lang;
using Exception = System.Exception;

// ReSharper disable once CheckNamespace
namespace Xamarin.Android.Crashlytics.Binding
{
    public partial class MonoException
    {
        /// <summary>
        ///     Format for stack trace entries with line numbers:
        ///     "at FullClassName. MethodName (MethodParams) in FileName :line LineNumber "
        /// </summary>
        private static readonly Regex ExpressionWithLineNumbers =
            new Regex(@"^at (?<ClassName>.+)\.(?<MethodName>.+) in (?<Filename>.*):(?<LineNumber>\d*)$");

        /// <summary>
        ///     /// Format for stack trace entries without line numbers:
        ///     "at FullClassName. MethodName (MethodParams)"
        /// </summary>
        private static readonly Regex ExpressionWithoutLineNumbers =
            new Regex(@"^at (?<ClassName>.+)\.(?<MethodName>.+)$");

        public static MonoException Create(Exception e)
        {
            string message = string.Format("({0}) {1}", e.GetType().Name, e.Message);
            StackTraceElement[] stackTraceElements = ParseStack(e.StackTrace ?? string.Empty).ToArray();
            return new MonoException(message, stackTraceElements);
        }

        private static IEnumerable<StackTraceElement> ParseStack(string stack)
        {
            if (stack != null)
            {
                string[] lines = stack.Split(new[] {"\r\n", "\n"}, StringSplitOptions.RemoveEmptyEntries);

                foreach (string line in lines)
                {
                    Match match = ExpressionWithLineNumbers.Match(line);
                    if (match.Success)
                        yield return StackTraceElementWithLineNumbers(match);
                    else
                    {
                        match = ExpressionWithoutLineNumbers.Match(line);
                        if (match.Success)
                            yield return StackTraceElementWithoutLineNumbers(match);
                        else
                            yield return StackTraceElement(line);
                    }
                }
            }
        }

        private static StackTraceElement StackTraceElement(string line)
        {
            return new StackTraceElement(line, "", "", 0);
        }

        private static StackTraceElement StackTraceElementWithLineNumbers(Match match)
        {
            int lineNumber = int.Parse(match.Groups["LineNumber"].Value);
            return new StackTraceElement(match.Groups["ClassName"].Value, match.Groups["MethodName"].Value,
                match.Groups["Filename"].Value, lineNumber);
        }

        private static StackTraceElement StackTraceElementWithoutLineNumbers(Match match)
        {
            return new StackTraceElement(match.Groups["ClassName"].Value, match.Groups["MethodName"].Value, "", 0);
        }
    }
}