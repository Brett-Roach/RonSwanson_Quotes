<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Quotes.aspx.cs" Inherits="RonSwanson_Quotes.Quotes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title></title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.0.0.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>

        <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            $(".rating-star-block .star").mouseleave(function () {
                $("#" + $(this).parent().attr('id') + " .star").each(function () {
                    $(this).addClass("outline");
                    $(this).removeClass("filled");
                });
            });
            $(".rating-star-block .star").mouseenter(function () {
                var hoverVal = $(this).attr('rating');
                $(this).prevUntil().addClass("filled");
                $(this).addClass("filled");
                $("#RAT").html(hoverVal);
            });
            $(".rating-star-block .star").click(function () {
                
                var v = $(this).attr('rating');
                var newScore = 0;
                var updateP = "#" + $(this).parent().attr('id') + ' .CurrentRating';
                var qotId = $("#" + $(this).parent().attr('id') + ' .quoteId').val();
                
                $("#" + $(this).parent().attr('id') + " .star").hide();
                $("#" + $(this).parent().attr('id') + " .yourRating").html("Your Rating is : &nbsp;<b style='color:#ff9900; font-size:15px'>" + v + "</b>");
                $.ajax({
                    type: "POST",
                    url: "Quotes.aspx/SaveRating",
                    data: "{quoteId: '" + qotId + "',rate: '" + v + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        setNewScore(updateP, data.d);
                    },
                    error: function (data) {
                        alert(data.d);
                    }
                });
            });
        });
        function setNewScore(container, data) {
            $(container).html(data);
            $("#myElem").show('1000').delay(2000).queue(function (n) {
                $(this).hide(); n();
            });
        }
    </script>

    <style type="text/css">
        .rating-star-block .star.outline {
            background: url("images/star-empty-icon.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
        }
        .rating-star-block .star.filled {
            background: url("images/star-full-icon.png") no-repeat scroll 0 0 rgba(0, 0, 0, 0);
        }
        .rating-star-block .star {
            color:rgba(0,0,0,0);
            display : inline-block;
            height:24px;
            overflow:hidden;
            text-indent:-999em;
            width:24px;
        }
        a {
            color:#005782;
            text-decoration:none;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="jumbotrom text-center">
	            <h1>Ron Swanson Quotes</h1>
                <asp:Image ID="swansonFaceImage" runat="server" ImageUrl="images\ronswanson.jpg" />
	            <p>Click the Button to get Swanson quote. Click the Boxes to Filter your results. Use the stars to rate the quote!</p>
                <asp:Button ID="getQuotesButton" runat="server" Text="Get a Swanson Quote!" OnClick="getQuotesButton_Click" />
                <br />
                <br />
                <asp:RadioButtonList ID="quoteSizeRadioButtonList" runat="server" RepeatDirection="Horizontal" align="center">
                    <asp:ListItem>Small</asp:ListItem>
                    <asp:ListItem>Medium</asp:ListItem>
                    <asp:ListItem>Large</asp:ListItem>
                </asp:RadioButtonList>
            </div>	
            <br />

            <div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CellPadding="5" align="center">
                    <Columns>
                        <asp:BoundField HeaderText="Quote Id" DataField="QuoteId" />
                        <asp:BoundField HeaderText="Quote Text" DataField="QuoteText" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div class="rating-star-block" id='div_<%#Container.DataItemIndex %>'>
                                    <input type="hidden" class="quoteId" value='<%#Eval("QuoteId") %>' />
                                    Current Rating :<span class="CurrentScore"><%#Eval("Rating") %></span><br /><div class="yourRating">Your Rating : </div> 
                                    <a class="star outline" href="#" rating="1" title="vote 1"> vote 1</a>
                                    <a class="star outline" href="#" rating="2" title="vote 2"> vote 2</a>
                                    <a class="star outline" href="#" rating="3" title="vote 3"> vote 3</a>
                                    <a class="star outline" href="#" rating="4" title="vote 4"> vote 4</a>
                                    <a class="star outline" href="#" rating="5" title="vote 5"> vote 5</a>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </form>
</body>
</html>
