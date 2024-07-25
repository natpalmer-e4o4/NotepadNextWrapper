using System.Diagnostics;

var argString = string.Empty;
if (args.Length > 0)
{
    argString = string.Join(' ', args);

    if (!argString.StartsWith('"'))
        argString = '"' + argString;

    if (!argString.EndsWith('"'))
        argString += '"';
}

const string wrapper = @"C:\Program Files\Notepad Next\wrapper.log";
var success = false;
var attempt = 0;
const int maxAttempt = 10;
while (!success && attempt < maxAttempt)
{
    attempt++;
    try
    {
        using (var inputStream = File.Open(wrapper, FileMode.Append, FileAccess.Write, FileShare.Write))
        {
            var sw = new StreamWriter(inputStream);
            sw.WriteLine(argString);
            sw.Flush();
            sw.Close();
        }
        success = true;
    }
    catch (Exception e)
    {
        // ignored
    }
}
Process.Start(@"C:\Program Files\Notepad Next\NotepadNext.exe", argString);